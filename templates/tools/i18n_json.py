#!/usr/bin/env python3
"""Generate templates/i18n/en.json from the template data.

Scans every template JSON under templates/data and collects all translation
ids used by it:

  * maintenance items : i18n_key -> label, desc_i18n_key -> description
  * parts             : i18n_key -> name
  * OBD-II DTCs       : desc_i18n_key -> description

The English default text (label / name / description) is written into
templates/i18n/en.json. _base/ files are scanned first, so the canonical base
text wins when several templates reuse the same key; reusing a key with
different text is reported as a warning (the reuse itself is a data issue).

Existing keys in en.json that are not referenced by any template are kept, so
curated/unused entries are never lost. Keys referenced by templates are
re-synced to the template text and new keys are appended at the end.

Run from the repo root:  python3 templates/tools/i18n_json.py
"""

import argparse
import json
import os
import sys

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
DEFAULT_DATA_ROOT = os.path.join(REPO_ROOT, "templates", "data")
DEFAULT_I18N = os.path.join(REPO_ROOT, "templates", "i18n", "en.json")


def iter_data_files(data_root):
    """Return template file paths, _base/ files first for canonical precedence."""
    base = []
    rest = []
    for dirpath, _dirs, files in os.walk(data_root):
        for fname in sorted(files):
            if not fname.endswith(".json"):
                continue
            rel = os.path.relpath(os.path.join(dirpath, fname), data_root)
            if os.path.basename(dirpath) == "_base":
                base.append(rel)
            else:
                rest.append(rel)
    return base + sorted(rest)


def collect(data_root):
    """Collect key -> English default, first-seen wins, _base/ files first."""
    strings = {}
    conflicts = []

    def add(key, value, origin):
        if not key or not value:
            return
        if key not in strings:
            strings[key] = value
        elif strings[key] != value:
            conflicts.append(f"{key}: {strings[key]!r} != {value!r} ({origin})")

    for rel in iter_data_files(data_root):
        with open(os.path.join(data_root, rel), encoding="utf-8") as fh:
            data = json.load(fh)
        for item in data.get("maintenance_items") or []:
            add(item.get("i18n_key"), item.get("label"), f"{rel} item {item.get('id')}")
            add(
                item.get("desc_i18n_key"),
                item.get("description"),
                f"{rel} item {item.get('id')}",
            )
        for part in data.get("parts") or []:
            add(part.get("i18n_key"), part.get("name"), f"{rel} part {part.get('id')}")
        for dtc in data.get("obd_dtc_definitions") or []:
            add(
                dtc.get("desc_i18n_key"),
                dtc.get("description"),
                f"{rel} dtc {dtc.get('code')}",
            )

    return strings, conflicts


def write(path, data):
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(json.dumps(data, ensure_ascii=False, indent=2) + "\n")


def main(argv=None):
    parser = argparse.ArgumentParser(
        description="Regenerate templates/i18n/en.json from template data"
    )
    parser.add_argument(
        "--check", action="store_true", help="report drift without writing"
    )
    parser.add_argument("--i18n", default=DEFAULT_I18N)
    parser.add_argument("--data-root", default=DEFAULT_DATA_ROOT)
    args = parser.parse_args(argv)

    strings, conflicts = collect(args.data_root)
    for conflict in sorted(conflicts):
        print(f"WARN {conflict}", file=sys.stderr)

    try:
        with open(args.i18n, encoding="utf-8") as fh:
            existing = json.load(fh)
    except FileNotFoundError:
        existing = {}

    new_keys = sorted(key for key in strings if key not in existing)
    changed = sorted(
        key for key in strings if key in existing and existing[key] != strings[key]
    )

    if args.check:
        if new_keys or changed:
            for key in new_keys:
                print(f"  + {key}")
            for key in changed:
                print(f"  ~ {key}: {existing[key]!r} -> {strings[key]!r}")
            return 1
        print("OK en.json is up to date")
        return 0

    merged = dict(existing)
    merged.update(strings)
    write(args.i18n, merged)
    print(
        f"en.json: {len(existing)} -> {len(merged)} keys "
        f"({len(new_keys)} added, {len(changed)} updated)"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
