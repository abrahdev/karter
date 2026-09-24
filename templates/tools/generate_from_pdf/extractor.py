"""AI-powered extraction of maintenance data from workshop manual text."""

import json
import os
import re
import sys
import time

try:
    from openai import BadRequestError, OpenAI
except ImportError:
    sys.exit("Missing dependency: run  pip install openai  first")

from rich.panel import Panel
from rich.live import Live

sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))
from _shared import load_prompt
from _shared.ui import console

MAX_RETRIES = 5
RETRY_BASE = 3

PROMPTS_FILE = os.path.join(os.path.dirname(__file__), "PROMPTS.md")
PROMPTS_DELTA_FILE = os.path.join(os.path.dirname(__file__), "PROMPTS_DELTA.md")
SCHEMA_PATH = os.path.join(
    os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))),
    "schemas",
    "template-v2.json",
)

# Only the tail of the response is shown live; full outputs can be ~14k tokens.
LIVE_TAIL = 3000

# Hard cap for a silent stream: an attempt fails once this passes with no
# content tokens, so a stuck upstream can never hang the tool silently.
FIRST_TOKEN_TIMEOUT = 180.0
# Short timeout for the pre-flight liveness probe (a tiny max_tokens=1 call).
PROBE_TIMEOUT = 30.0


def _slugify(text: str) -> str:
    """Normalize an id to a lowercase slug (letters, digits, dashes)."""
    text = re.sub(r"[^a-z0-9\-]", "-", text.lower())
    return re.sub(r"-+", "-", text).strip("-")


def _strip_code_fences(text: str) -> str:
    """Remove markdown code fences (```json ... ```) around a raw response."""
    text = text.strip()
    if text.startswith("```"):
        text = re.sub(r"^```[a-zA-Z]*\n?", "", text)
        text = re.sub(r"\n?```$", "", text)
    return text


def _render_live(chunks, elapsed, reasoning=""):
    """Renderable for the live streaming window."""
    text = "".join(chunks)
    if text:
        body = text[-LIVE_TAIL:]
    elif reasoning:
        body = f"[dim]reasoning… {elapsed:.0f}s[/dim]\n{reasoning[-LIVE_TAIL:]}"
    else:
        body = f"[dim]waiting for the AI response… {elapsed:.0f}s[/dim]"
    return Panel(body, title="AI response (JSON)", border_style="yellow")


class StreamResult:
    """Outcome of a streamed chat completion.

    ``reasoning`` holds the model's chain-of-thought tokens (when the model
    exposes them, e.g. ``delta.reasoning_content``), and ``finish_reason`` the
    terminal reason ("stop", "length", ...). A ``content`` that is empty while
    ``reasoning`` is not means the model reasoned but produced no JSON.
    """

    __slots__ = ("content", "reasoning", "finish_reason")

    def __init__(self, content, reasoning="", finish_reason=None):
        self.content = content
        self.reasoning = reasoning
        self.finish_reason = finish_reason


def _stream_content(client, kwargs, timeout=FIRST_TOKEN_TIMEOUT):
    """Stream a chat completion, updating a live window as tokens arrive.

    Shows an elapsed-time counter while waiting for the first token, and
    raises ``TimeoutError`` if nothing arrives within ``timeout`` seconds so
    the caller's retry loop can act instead of hanging silently.

    Reasoning tokens are captured separately and surfaced in the live window.

    Returns:
        A ``StreamResult`` with the response text, reasoning text and
        finish_reason.
    """
    chunks = []
    reasoning = []
    finish_reason = None
    started = time.monotonic()
    live = Live(_render_live(chunks, 0.0), console=console, refresh_per_second=8)
    with live:
        stream = client.chat.completions.create(**kwargs)
        for chunk in stream:
            if not chunk.choices:
                continue
            choice = chunk.choices[0]
            delta = choice.delta
            if delta:
                if getattr(delta, "content", None):
                    chunks.append(delta.content)
                reason = getattr(delta, "reasoning_content", None) or getattr(
                    delta, "reasoning", None
                )
                if reason:
                    reasoning.append(reason)
            if getattr(choice, "finish_reason", None):
                finish_reason = choice.finish_reason
            elapsed = time.monotonic() - started
            if not chunks and not reasoning and elapsed > timeout:
                raise TimeoutError(
                    f"no content received from the model in {elapsed:.0f}s"
                )
            live.update(_render_live(chunks, elapsed, "".join(reasoning)))
    return StreamResult("".join(chunks), "".join(reasoning), finish_reason)


def _probe_endpoint(client, model, timeout=PROBE_TIMEOUT):
    """Send a tiny request to confirm the endpoint answers for ``model``.

    Runs once before the heavy request so a dead/unreachable endpoint fails
    fast with a clear message instead of stalling on the full manual text.

    Returns:
        True when the probe succeeded, False when it failed (the heavy request
        is still attempted, since some providers reject tiny pings).
    """
    console.print(f"[dim]  Probing endpoint ({model})…[/]")
    started = time.monotonic()
    try:
        client.chat.completions.create(
            model=model,
            temperature=0,
            max_tokens=1,
            timeout=timeout,
            messages=[{"role": "user", "content": "ping"}],
        )
        console.print(
            f"[dim]  ✓ endpoint responding ({time.monotonic() - started:.1f}s)[/]"
        )
        return True
    except Exception as exc:
        console.print(
            f"[yellow]  ⚠ endpoint probe failed ({type(exc).__name__}: {exc}) — "
            f"attempting anyway[/]"
        )
        return False


def _load_schema() -> str:
    """Content of the template JSON Schema (template-v2.json)."""
    with open(SCHEMA_PATH, encoding="utf-8") as fh:
        return fh.read().strip()


def build_delta_prompt(base: dict, language: str) -> str:
    """System prompt for delta generation over a resolved base."""
    return load_prompt(
        PROMPTS_DELTA_FILE,
        language=language,
        base_json=json.dumps(base, ensure_ascii=False, indent=2),
        schema=_load_schema(),
    )


def extract_with_ai(
    client: OpenAI,
    model: str,
    pdf_text: str,
    language: str,
    max_tokens: int = 32000,
    timeout: float = FIRST_TOKEN_TIMEOUT,
    base: dict | None = None,
) -> tuple[dict, str]:
    """Extract maintenance data from PDF text using AI.

    Streams the response into a live window and returns both the parsed JSON
    and the raw response text. A tiny liveness probe runs first so a dead
    endpoint fails fast instead of stalling on the full manual.

    Args:
        client: OpenAI client instance
        model: Model ID to use
        pdf_text: Extracted text from PDF
        language: Detected or specified language
        max_tokens: Maximum tokens for response
        timeout: Per-attempt timeout in seconds (large manuals can be slow).
        base: Resolved base template to generate a delta over. When given, the
            delta prompt is used and the model emits only overrides/additions.

    Returns:
        (data, raw_content) tuple.
    """
    if base is not None:
        system_prompt = build_delta_prompt(base, language)
    else:
        system_prompt = load_prompt(PROMPTS_FILE, language=language)

    # Truncate text if too long (most models have context limits)
    max_chars = 100000  # ~25k tokens
    if len(pdf_text) > max_chars:
        pdf_text = pdf_text[:max_chars] + "\n\n[TRUNCATED]"
        console.print("[yellow]⚠ PDF text truncated due to length[/]")

    _probe_endpoint(client, model)

    last_error = None
    last_stream = None
    use_json_format = True
    for attempt in range(MAX_RETRIES):
        try:
            console.print(
                f"[dim]  Attempt {attempt + 1}/{MAX_RETRIES} · {model} · "
                f"json_object={use_json_format} · {len(pdf_text):,} chars[/]"
            )

            base_kwargs = {
                "model": model,
                "temperature": 0.2,
                "max_tokens": max_tokens,
                "timeout": timeout,
                "stream": True,
                "messages": [
                    {"role": "system", "content": system_prompt},
                    {
                        "role": "user",
                        "content": f"Extract maintenance data from this workshop manual:\n\n{pdf_text}",
                    },
                ],
            }

            # Some endpoints don't support json_object with streaming; retry
            # without it (the flag persists for the rest of this run).
            kwargs = dict(base_kwargs)
            if use_json_format:
                kwargs["response_format"] = {"type": "json_object"}
            try:
                result = _stream_content(client, kwargs)
                last_stream = result
                raw = result.content
            except BadRequestError:
                use_json_format = False
                result = _stream_content(client, base_kwargs)
                last_stream = result
                raw = result.content

            data = json.loads(_strip_code_fences(raw))

            # Basic validation
            if "id" not in data or "meta" not in data:
                raise ValueError("Missing required fields: id, meta")

            return data, raw

        except json.JSONDecodeError as e:
            last_error = e
            if (
                last_stream is not None
                and not last_stream.content
                and last_stream.reasoning
            ):
                console.print(
                    f"[yellow]  Model reasoned but emitted no JSON "
                    f"(finish_reason={last_stream.finish_reason})[/]"
                )
            else:
                console.print(f"[yellow]  JSON parse error: {e}[/]")
        except Exception as e:
            last_error = e
            console.print(f"[yellow]  Error: {type(e).__name__}: {e}[/]")

        if attempt < MAX_RETRIES - 1:
            wait = RETRY_BASE * (2**attempt)
            console.print(f"[dim]  Retrying in {wait}s...[/]")
            time.sleep(wait)

    raise RuntimeError(f"Extraction failed after {MAX_RETRIES} attempts: {last_error}")


def _drop_nulls(value):
    """Recursively remove null dict values so optional fields are omitted
    instead of emitted as ``null`` (the schema rejects ``null`` for string/int
    types). List contents are preserved as-is, because some schemas allow null
    elements (e.g. ``meta.years: [2019, null]``)."""
    if isinstance(value, dict):
        return {k: _drop_nulls(v) for k, v in value.items() if v is not None}
    if isinstance(value, list):
        return [_drop_nulls(v) for v in value]
    return value


def clean_extracted_data(data: dict) -> dict:
    """Clean and normalize extracted data.

    - Omit fields with null values (the schema only allows real values)
    - Ensure IDs are valid slugs
    - Remove empty arrays
    - Normalize field names
    """
    data = _drop_nulls(data)

    # Clean vehicle ID
    if "id" in data:
        data["id"] = _slugify(data["id"])

    # Clean part IDs
    for part in data.get("parts") or []:
        if "id" in part:
            part["id"] = _slugify(part["id"])

    # Clean maintenance item IDs
    for item in data.get("maintenance_items") or []:
        if "id" in item:
            item["id"] = _slugify(item["id"])

    # Remove empty arrays
    for key in ["parts", "maintenance_items", "obd_dtc_definitions"]:
        if key in data and not data[key]:
            del data[key]

    return data