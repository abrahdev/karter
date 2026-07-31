#!/usr/bin/env python3
"""Import OBD-II DTC data from Wal33D/dtc-database (MIT) into the templates.

Downloads plain-text source files, parses ``CODE - Description`` lines into
``obd_dtc_definitions`` entries, and writes:
  * standard SAE codes (P/B/C/U) into ``_base/common-all.json``
  * generic manufacturer codes (other) into ``_base/common-all.json``
  * per-brand manufacturer codes into ``templates/data/<brand>/dtc.json``

Run from the repo root:  python3 tools/import_dtc.py
"""

import json
import re
import sys
import urllib.request
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
DATA_DIR = REPO_ROOT / "templates" / "data"
SOURCE_URL = (
    "https://raw.githubusercontent.com/Wal33D/dtc-database/main/data/source-data"
)
SOURCE_REPO = "https://github.com/Wal33D/dtc-database"
CODE_RE = re.compile(r"^[PCBU][0-9A-F]{4}$")

STANDARD_FILES = [
    "p_codes.txt",
    "b_codes.txt",
    "c_codes.txt",
    "u_codes.txt",
]

BRAND_FILES = {
    "audi": "audi_codes.txt",
    "bmw": "bmw_codes.txt",
    "chevrolet": "chevy_codes.txt",
    "ford": "ford_codes.txt",
    "honda": "honda_codes.txt",
    "jeep": "jeep_codes.txt",
    "kia": "kia_codes.txt",
    "mazda": "mazda_codes.txt",
    "mercedes-benz": "mercedes_codes.txt",
    "mitsubishi": "mitsubishi_codes.txt",
    "nissan": "nissan_codes.txt",
    "subaru": "subaru_codes.txt",
    "suzuki": "suzuki_codes.txt",
    "toyota": "toyota_codes.txt",
    "volkswagen": "volkswagen_codes.txt",
}

BRAND_DISPLAY = {
    "audi": "Audi",
    "bmw": "BMW",
    "chevrolet": "Chevrolet",
    "ford": "Ford",
    "honda": "Honda",
    "jeep": "Jeep",
    "kia": "Kia",
    "mazda": "Mazda",
    "mercedes-benz": "Mercedes-Benz",
    "mitsubishi": "Mitsubishi",
    "nissan": "Nissan",
    "subaru": "Subaru",
    "suzuki": "Suzuki",
    "toyota": "Toyota",
    "volkswagen": "Volkswagen",
}


def fetch(name: str) -> str:
    url = f"{SOURCE_URL}/{name}"
    with urllib.request.urlopen(url, timeout=60) as resp:
        return resp.read().decode("utf-8")


def parse_codes(text: str):
    """Yield (code, description) for valid ``CODE - Description`` lines."""
    seen = set()
    dropped = 0
    for raw in text.splitlines():
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        if " - " not in line:
            dropped += 1
            continue
        code, description = line.split(" - ", 1)
        code = code.strip().upper()
        description = description.strip()
        if not CODE_RE.match(code):
            dropped += 1
            continue
        if code in seen:
            continue
        seen.add(code)
        yield code, description
    if dropped:
        print(f"  dropped {dropped} malformed/duplicate lines")


def make_entry(code, description, scope):
    return {
        "code": code,
        "scope": scope,
        "description": description,
    }


def write_json(path: Path, data) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
        f.write("\n")
    print(f"  wrote {path.relative_to(REPO_ROOT)}")


def validate(schema_path: Path, docs):
    from jsonschema import Draft7Validator

    schema = json.loads(schema_path.read_text(encoding="utf-8"))
    validator = Draft7Validator(schema)
    errors = 0
    for doc in docs:
        for err in validator.iter_errors(doc):
            errors += 1
            print(f"  INVALID {err.json_path}: {err.message}")
    return errors


def main():
    downloaded = {}

    standard = []
    print("Fetching standard SAE codes...")
    for name in STANDARD_FILES:
        print(f"  {name}")
        downloaded[name] = fetch(name)
        for code, desc in parse_codes(downloaded[name]):
            standard.append(make_entry(code, desc, "standard"))

    print("Fetching generic manufacturer codes...")
    generic = []
    standard_codes = {e["code"] for e in standard}
    downloaded["other_codes.txt"] = fetch("other_codes.txt")
    for code, desc in parse_codes(downloaded["other_codes.txt"]):
        if code in standard_codes:
            continue
        generic.append(make_entry(code, desc, "manufacturer"))

    print(f"  standard: {len(standard)} codes")
    print(f"  generic manufacturer: {len(generic)} codes")

    common_path = DATA_DIR / "_base" / "common-all.json"
    common = json.loads(common_path.read_text(encoding="utf-8"))
    common["obd_dtc_definitions"] = standard + generic
    write_json(common_path, common)

    docs = [common]

    print("Fetching per-brand codes...")
    for brand, name in BRAND_FILES.items():
        print(f"  {brand}")
        downloaded[name] = fetch(name)
        entries = [
            make_entry(code, desc, "manufacturer")
            for code, desc in parse_codes(downloaded[name])
        ]
        dtc = {
            "id": f"{brand}-dtc",
            "meta": {
                "make": BRAND_DISPLAY[brand],
                "model": "OBD-II codes",
                "author": "abrahdev",
                "version": "1.0.0",
                "sources": [f"{SOURCE_REPO} (MIT)"],
            },
            "obd_dtc_definitions": entries,
        }
        docs.append(dtc)
        write_json(DATA_DIR / brand / "dtc.json", dtc)
        print(f"  {brand}: {len(entries)} codes")

    schema_path = REPO_ROOT / "templates" / "schemas" / "template-v2.json"
    errors = validate(schema_path, docs)
    if errors:
        print(f"\nValidation failed: {errors} error(s)")
        sys.exit(1)
    print("\nValidation OK.")


if __name__ == "__main__":
    main()
