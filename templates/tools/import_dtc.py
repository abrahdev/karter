#!/usr/bin/env python3
"""Import OBD-II DTC data from Wal33D/dtc-database (MIT) into the templates.

Downloads plain-text source files, parses ``CODE - Description`` lines into
``obd_dtc_definitions`` entries, and writes:
  * standard SAE codes (P/B/C/U) into ``_base/dtc.json``
  * generic manufacturer codes (other) into ``_base/dtc.json``
  * per-brand manufacturer codes into ``templates/data/<brand>/dtc.json``

Each entry gets a ``desc_i18n_key`` used for localizable descriptions:
  * standard/generic codes: ``dtc_<code>`` (e.g. ``dtc_p0171``)
  * manufacturer codes: ``dtc_<brand>_<code>`` (e.g. ``dtc_mercedes_benz_p1100``)

The keys are merged into ``i18n/{en,es,et}.json`` with the English text.
The merge is idempotent: existing keys (e.g. Weblate translations) are kept.

Run from the repo root:  python3 templates/tools/import_dtc.py
"""

import json
import re
import sys
import urllib.request
from pathlib import Path

TEMPLATES_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = TEMPLATES_DIR / "data"
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
    "acura": "acura_codes.txt",
    "audi": "audi_codes.txt",
    "bmw": "bmw_codes.txt",
    "buick": "buick_codes.txt",
    "cadillac": "cadillac_codes.txt",
    "chevrolet": "chevy_codes.txt",
    "chrysler": "chrysler_codes.txt",
    "dodge": "dodge_codes.txt",
    "ford": "ford_codes.txt",
    "geo": "geo_codes.txt",
    "gm": "gm_codes.txt",
    "gmc": "gmc_codes.txt",
    "honda": "honda_codes.txt",
    "infiniti": "infiniti_codes.txt",
    "jaguar": "jaguar_codes.txt",
    "jeep": "jeep_codes.txt",
    "kia": "kia_codes.txt",
    "lexus": "lexus_codes.txt",
    "lincoln": "lincoln_codes.txt",
    "mazda": "mazda_codes.txt",
    "mercedes-benz": "mercedes_codes.txt",
    "mercury": "mercury_codes.txt",
    "mitsubishi": "mitsubishi_codes.txt",
    "nissan": "nissan_codes.txt",
    "oldsmobile": "oldsmobile_codes.txt",
    "plymouth": "plymouth_codes.txt",
    "pontiac": "pontiac_codes.txt",
    "saturn": "saturn_codes.txt",
    "subaru": "subaru_codes.txt",
    "suzuki": "suzuki_codes.txt",
    "toyota": "toyota_codes.txt",
    "volkswagen": "volkswagen_codes.txt",
}

BRAND_DISPLAY = {
    "acura": "Acura",
    "audi": "Audi",
    "bmw": "BMW",
    "buick": "Buick",
    "cadillac": "Cadillac",
    "chevrolet": "Chevrolet",
    "chrysler": "Chrysler",
    "dodge": "Dodge",
    "ford": "Ford",
    "geo": "Geo",
    "gm": "GM",
    "gmc": "GMC",
    "honda": "Honda",
    "infiniti": "Infiniti",
    "jaguar": "Jaguar",
    "jeep": "Jeep",
    "kia": "Kia",
    "lexus": "Lexus",
    "lincoln": "Lincoln",
    "mazda": "Mazda",
    "mercedes-benz": "Mercedes-Benz",
    "mercury": "Mercury",
    "mitsubishi": "Mitsubishi",
    "nissan": "Nissan",
    "oldsmobile": "Oldsmobile",
    "plymouth": "Plymouth",
    "pontiac": "Pontiac",
    "saturn": "Saturn",
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


def make_entry(code, description, scope, key):
    return {
        "code": code,
        "scope": scope,
        "desc_i18n_key": key,
        "description": description,
    }


def write_json(path: Path, data) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
        f.write("\n")
    print(f"  wrote {path.relative_to(TEMPLATES_DIR)}")


def update_i18n(translations) -> None:
    """Merge DTC descriptions into en/es/et.json without overwriting keys.

    ``dtc_*`` keys are owned by the importer: stale ones (absent from the
    source) are pruned, while other keys (e.g. Weblate translations) are kept.
    """
    for lang in ("en", "es", "et"):
        path = TEMPLATES_DIR / "i18n" / f"{lang}.json"
        data = json.loads(path.read_text(encoding="utf-8"))
        added = 0
        for key in [k for k in data if k.startswith("dtc_") and k not in translations]:
            del data[key]
        for key, text in translations.items():
            if key not in data:
                data[key] = text
                added += 1
        write_json(path, data)
        print(f"  {lang}: {added} new keys ({len(data)} total)")


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
    translations = {}

    standard = []
    print("Fetching standard SAE codes...")
    for name in STANDARD_FILES:
        print(f"  {name}")
        downloaded[name] = fetch(name)
        for code, desc in parse_codes(downloaded[name]):
            standard.append(make_entry(code, desc, "standard", f"dtc_{code.lower()}"))
            translations[f"dtc_{code.lower()}"] = desc

    print("Fetching generic manufacturer codes...")
    generic = []
    standard_codes = {e["code"] for e in standard}
    downloaded["other_codes.txt"] = fetch("other_codes.txt")
    for code, desc in parse_codes(downloaded["other_codes.txt"]):
        if code in standard_codes:
            continue
        generic.append(make_entry(code, desc, "manufacturer", f"dtc_{code.lower()}"))
        translations[f"dtc_{code.lower()}"] = desc

    print(f"  standard: {len(standard)} codes")
    print(f"  generic manufacturer: {len(generic)} codes")

    dtc_path = DATA_DIR / "_base" / "dtc.json"
    dtc = {
        "id": "dtc-general",
        "meta": {
            "make": "_base",
            "model": "OBD-II codes (standard & generic)",
            "author": "abrahdev",
            "version": "1.0.0",
            "sources": [f"{SOURCE_REPO} (MIT)"],
        },
        "obd_dtc_definitions": standard + generic,
    }
    write_json(dtc_path, dtc)

    docs = [dtc]

    print("Fetching per-brand codes...")
    for brand, name in BRAND_FILES.items():
        print(f"  {brand}")
        prefix = f"dtc_{brand.replace('-', '_')}_"
        downloaded[name] = fetch(name)
        entries = []
        for code, desc in parse_codes(downloaded[name]):
            entries.append(make_entry(code, desc, "manufacturer", f"{prefix}{code.lower()}"))
            translations[f"{prefix}{code.lower()}"] = desc
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

    print(f"\nUpdating i18n files...")
    update_i18n(translations)

    schema_path = TEMPLATES_DIR / "schemas" / "template-v2.json"
    errors = validate(schema_path, docs)
    if errors:
        print(f"\nValidation failed: {errors} error(s)")
        sys.exit(1)
    print("\nValidation OK.")


if __name__ == "__main__":
    main()
