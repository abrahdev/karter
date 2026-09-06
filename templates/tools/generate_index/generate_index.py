#!/usr/bin/env python3
"""Scan templates/ directory and auto-generate index.json."""

import json
import os
from datetime import datetime, timezone
from pathlib import Path

TEMPLATES_DIR = Path(__file__).resolve().parent.parent.parent
INDEX_FILE = TEMPLATES_DIR / "index.json"
SCHEMA_DIR_NAME = "schemas"


def load_json(path: Path) -> dict:
    with open(path, encoding="utf-8") as f:
        return json.load(f)


def write_json(path: Path, data) -> None:
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
        f.write("\n")
    print(f"  wrote {path}")


def generate_index():
    templates = []

    for root, _dirs, files in os.walk(TEMPLATES_DIR):
        root_path = Path(root)
        # Skip schemas directory
        if SCHEMA_DIR_NAME in root_path.parts:
            continue

        for file in files:
            if not file.endswith(".json"):
                continue
            filepath = root_path / file
            relpath = filepath.relative_to(TEMPLATES_DIR)

            # Skip index.json itself
            if relpath.name == "index.json":
                continue

            try:
                data = load_json(filepath)
            except (json.JSONDecodeError, KeyError) as e:
                print(f"  WARN: skipping {relpath}: {e}")
                continue

            if "id" not in data or "meta" not in data:
                print(f"  WARN: skipping {relpath}: missing id or meta")
                continue

            # Skip non-vehicle fragments (DTC/parts data) that other
            # templates extend but are not selectable vehicle templates.
            if "maintenance_items" not in data:
                print(f"  INFO: skipping fragment {relpath}")
                continue

            meta = data["meta"]
            extends = data.get("extends", [])
            items = data.get("maintenance_items", [])

            item_count = sum(
                1 for item in items if not item.get("remove", False)
            )

            entry = {
                "id": data["id"],
                "path": str(relpath),
                "meta": meta,
                "item_count": item_count,
                "extends": extends,
            }

            templates.append(entry)

    # Sort: _base first, then alphabetical by make/model
    templates.sort(
        key=lambda t: (
            0 if t["meta"].get("make") == "_base" else 1,
            t["meta"].get("make", "").lower(),
            t["meta"].get("model", "").lower(),
            t["id"],
        )
    )

    index = {
        "generated_at": datetime.now(timezone.utc).strftime(
            "%Y-%m-%dT%H:%M:%SZ"
        ),
        "schema_version": "1",
        "templates": templates,
    }

    write_json(INDEX_FILE, index)
    print(f"\nIndex generated: {len(templates)} entries.")


if __name__ == "__main__":
    generate_index()
