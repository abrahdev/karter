"""Phase-1 planning for the PDF template generator.

Given a workshop manual, decides how to integrate it into the catalog by
tool-calling: the model may read existing templates, then emits a plan with
the leaf base it will extend and the target path where the generated file
will be written. The brand ``dtc.json`` extends entry is added by the tool,
never by the model.
"""

import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))
from _shared import load_prompt
from _shared.ui import console

from extractor import _strip_code_fences

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
DATA_DIR = os.path.join(REPO_ROOT, "templates", "data")
BASE_DIR = os.path.join(DATA_DIR, "_base")
PROMPTS_FILE = os.path.join(os.path.dirname(__file__), "PROMPTS_PLAN.md")
SCHEMA_PATH = os.path.join(REPO_ROOT, "templates", "schemas", "template-v2.json")

# The leaf bases a generated template may extend (the `*-common` and `dtc.json`
# files are parents, not extend targets).
LEAF_BASES = [
    "_base/car-combustion.json",
    "_base/car-diesel.json",
    "_base/car-electric.json",
    "_base/motorcycle-2t.json",
    "_base/motorcycle-4t.json",
    "_base/motorcycle-ev.json",
]

MAX_TOOL_ITERATIONS = 12
MAX_FILE_CHARS = 40000

READ_FILE_TOOL = {
    "type": "function",
    "function": {
        "name": "read_file",
        "description": (
            "Read a JSON file under templates/data/ by its relative path "
            "(e.g. 'bmw/x3/base.json') to inspect an existing template."
        ),
        "parameters": {
            "type": "object",
            "properties": {
                "path": {
                    "type": "string",
                    "description": "Relative path under templates/data/",
                }
            },
            "required": ["path"],
        },
    },
}


def _data_path(rel: str) -> str | None:
    """Resolve a relative path under DATA_DIR, or None if unsafe."""
    if not rel or os.path.isabs(rel) or not rel.endswith(".json"):
        return None
    full = os.path.normpath(os.path.join(DATA_DIR, rel))
    if not full.startswith(DATA_DIR + os.sep):
        return None
    return full


def read_file(rel: str) -> str:
    """Sandboxed file read for the read_file tool (returns JSON text)."""
    full = _data_path(rel)
    if full is None or not os.path.exists(full):
        return json.dumps({"error": f"not found or unsafe path: {rel}"})
    with open(full, encoding="utf-8") as fh:
        content = fh.read()
    if len(content) > MAX_FILE_CHARS:
        content = content[:MAX_FILE_CHARS] + "\n...[truncated]"
    return content


def build_tree() -> str:
    """Render a text tree of templates/data/ (all files, nothing excluded)."""
    lines = ["templates/data/"]

    def walk(dir_path, prefix):
        entries = sorted(os.listdir(dir_path))
        dirs = [e for e in entries if os.path.isdir(os.path.join(dir_path, e))]
        files = [e for e in entries if e.endswith(".json")]
        items = dirs + files
        for i, name in enumerate(items):
            last = i == len(items) - 1
            lines.append(prefix + ("└── " if last else "├── ") + name)
            full = os.path.join(dir_path, name)
            if os.path.isdir(full):
                walk(full, prefix + ("    " if last else "│   "))

    walk(DATA_DIR, "")
    return "\n".join(lines)


def base_templates_context() -> str:
    """Full JSON of every _base/*.json except dtc.json, for the prompt."""
    blocks = []
    for name in sorted(os.listdir(BASE_DIR)):
        if name == "dtc.json":
            continue
        path = os.path.join(BASE_DIR, name)
        with open(path, encoding="utf-8") as fh:
            blocks.append(f"### _base/{name}\n{fh.read().strip()}")
    return "\n\n".join(blocks)


def resolved_base(base_path: str) -> dict:
    """Resolve a leaf base chain into a flat parts/items dict for phase 2."""
    sys.path.insert(0, os.path.join(REPO_ROOT, "templates", "tools", "build_catalog"))
    import build_catalog as bc

    res = bc.resolve(base_path, DATA_DIR, {}, set())
    return {
        "parts": [
            {
                "id": p.id,
                "name": p.name,
                "i18n_key": p.i18n_key,
                "quantity": p.quantity,
                "unit": p.unit,
                "description": p.description,
            }
            for p in res.parts.values()
        ],
        "maintenance_items": [
            {
                "id": i.id,
                "label": i.label,
                "i18n_key": i.i18n_key,
                "desc_i18n_key": i.desc_i18n_key,
                "interval_km": i.interval_km,
                "interval_months": i.interval_months,
                "description": i.description,
                "parts": [{"part_id": pid, "quantity": q} for pid, q in i.parts.items()],
            }
            for i in res.items.values()
        ],
    }


def validate_plan(plan: dict) -> list[str]:
    """Check a phase-1 plan for safe, consistent values."""
    errors = []
    base = plan.get("base")
    if base is not None and base not in LEAF_BASES:
        errors.append(f"invalid base: {base!r}")
    tp = plan.get("target_path")
    if not tp:
        errors.append("missing target_path")
    elif _data_path(tp) is None:
        errors.append(f"unsafe target_path: {tp!r}")
    elif tp.split("/")[0] in ("_base",):
        errors.append("target_path must live under a make folder")
    for key in ("make", "model"):
        if not plan.get(key):
            errors.append(f"missing {key}")
    return errors


def _assistant_tool_message(msg) -> dict:
    return {
        "role": "assistant",
        "content": msg.content or "",
        "tool_calls": [
            {
                "id": tc.id,
                "type": "function",
                "function": {
                    "name": tc.function.name,
                    "arguments": tc.function.arguments,
                },
            }
            for tc in msg.tool_calls
        ],
    }


def build_plan_system() -> str:
    """System prompt for phase 1: leaf bases, JSON schema and the data tree."""
    return load_prompt(
        PROMPTS_FILE,
        leaf_bases="\n".join(f"- {b}" for b in LEAF_BASES),
        base_templates=base_templates_context(),
        schema=load_schema(),
        tree=build_tree(),
    )


def load_schema() -> str:
    """Content of the template JSON Schema (template-v2.json)."""
    with open(SCHEMA_PATH, encoding="utf-8") as fh:
        return fh.read().strip()


def plan(client, model: str, pdf_text: str, language: str) -> dict:
    """Run the phase-1 tool-calling loop and return the plan dict."""
    messages = [
        {"role": "system", "content": build_plan_system()},
        {
            "role": "user",
            "content": (
                f"Language of the manual: {language}\n\n"
                f"Workshop manual text:\n\n{pdf_text}"
            ),
        },
    ]
    for _ in range(MAX_TOOL_ITERATIONS):
        resp = client.chat.completions.create(
            model=model,
            temperature=0.1,
            tools=[READ_FILE_TOOL],
            tool_choice="auto",
            messages=messages,
        )
        msg = resp.choices[0].message
        if msg.tool_calls:
            console.print(
                f"[dim]  plan: read_file "
                f"({', '.join(_tool_name(tc) for tc in msg.tool_calls)})[/]"
            )
            messages.append(_assistant_tool_message(msg))
            for tc in msg.tool_calls:
                try:
                    args = json.loads(tc.function.arguments or "{}")
                except json.JSONDecodeError:
                    args = {}
                messages.append(
                    {
                        "role": "tool",
                        "tool_call_id": tc.id,
                        "content": read_file(args.get("path", "")),
                    }
                )
            continue
        return json.loads(_strip_code_fences(msg.content or ""))
    raise RuntimeError(
        f"planning did not converge within {MAX_TOOL_ITERATIONS} tool calls"
    )


def _tool_name(tc) -> str:
    try:
        args = json.loads(tc.function.arguments or "{}")
    except json.JSONDecodeError:
        return tc.function.name
    return args.get("path", tc.function.name)