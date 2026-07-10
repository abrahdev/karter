#!/usr/bin/env python3
"""Generate brand/model template files for MVP.

Each base.json inherits from _base/combustion.json by default.
Only add overrides when the data is well-known and factual.
"""

import json
import os
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
TEMPLATES_DIR = REPO_ROOT / "mobile" / "templates"


def write_json(path: Path, data) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
        f.write("\n")
    print(f"  created {path.relative_to(TEMPLATES_DIR)}")


# Each entry: (brand, model, overrides_or_empty_list) or (brand, model, overrides, custom_id)
# overrides: list of dicts with item overrides (id + fields to change)
# Use {"id": "...", "remove": True} to remove an inherited item
#
# Models with timing chain: remove timing-belt (inherited from combustion.json)
# All data here is based on common knowledge of each model's engine family.

models = [
    # ── Ford ────────────────────────────────────────────────
    (
        "Ford",
        "Fiesta",
        [
            {
                "id": "timing-belt",
                "interval_km": 160000,
                "interval_months": 60,
                "description": "Ford specifies timing belt replacement. Replace water pump simultaneously.",
            },
        ],
    ),
    (
        "Ford",
        "Focus",
        [
            {
                "id": "timing-belt",
                "interval_km": 160000,
                "interval_months": 60,
                "description": "Ford specifies timing belt replacement. Replace water pump simultaneously.",
            },
        ],
    ),
    ("Ford", "Ranger", []),
    # ── Honda ───────────────────────────────────────────────
    (
        "Honda",
        "Civic",
        [
            {
                "id": "timing-belt",
                "remove": True,
                "description": "Honda K-series, L-series, and R-series engines use timing chains, not belts.",
            },
            {
                "id": "spark-plugs",
                "interval_km": 100000,
                "description": "Iridium spark plugs on most Civic generations last up to 100k km.",
            },
        ],
    ),
    (
        "Honda",
        "CR-V",
        [
            {
                "id": "timing-belt",
                "remove": True,
                "description": "Honda CR-V uses timing chain (K24, L15 engines).",
            },
        ],
    ),
    (
        "Honda",
        "HR-V",
        [
            {
                "id": "timing-belt",
                "remove": True,
                "description": "Honda HR-V uses timing chain (L15 engine).",
            },
        ],
    ),
    # ── Chevrolet ────────────────────────────────────────────
    (
        "Chevrolet",
        "Onix",
        [
            {
                "id": "timing-belt",
                "remove": True,
                "description": "Chevrolet Onix engines (1.0L/1.4L) use timing chains.",
            },
        ],
    ),
    ("Chevrolet", "Cruze", []),
    ("Chevrolet", "Tracker", []),
    # ── Nissan ──────────────────────────────────────────────
    ("Nissan", "Sentra", []),
    (
        "Nissan",
        "Versa",
        [
            {
                "id": "timing-belt",
                "remove": True,
                "description": "Nissan Versa (HR16DE engine) uses a timing chain.",
            },
        ],
    ),
    (
        "Nissan",
        "Kicks",
        [
            {
                "id": "timing-belt",
                "remove": True,
                "description": "Nissan Kicks (HR16DE engine) uses a timing chain.",
            },
        ],
    ),
    # ── Hyundai ─────────────────────────────────────────────
    (
        "Hyundai",
        "Elantra",
        [
            {
                "id": "timing-belt",
                "remove": True,
                "description": "Hyundai Elantra uses timing chains (Gamma, Kappa, Smartstream engines).",
            },
        ],
    ),
    (
        "Hyundai",
        "Tucson",
        [
            {
                "id": "timing-belt",
                "remove": True,
                "description": "Hyundai Tucson uses timing chains (Theta, Gamma, Smartstream engines).",
            },
        ],
    ),
    # ── Kia ─────────────────────────────────────────────────
    (
        "Kia",
        "Rio",
        [
            {
                "id": "timing-belt",
                "remove": True,
                "description": "Kia Rio (Gamma engine) uses a timing chain.",
            },
        ],
    ),
    (
        "Kia",
        "Sportage",
        [
            {
                "id": "timing-belt",
                "remove": True,
                "description": "Kia Sportage uses timing chain (Theta II, Gamma, Smartstream engines).",
            },
        ],
    ),
    # ── Renault ─────────────────────────────────────────────
    ("Renault", "Clio", []),
    ("Renault", "Megane", []),
    ("Renault", "Duster", []),
    # ── Peugeot ─────────────────────────────────────────────
    ("Peugeot", "208", []),
    ("Peugeot", "308", []),
    ("Peugeot", "3008", []),
    # ── Fiat ────────────────────────────────────────────────
    ("Fiat", "Uno", []),
    ("Fiat", "Strada", []),
    ("Fiat", "Mobi", []),
    # ── Suzuki ──────────────────────────────────────────────
    (
        "Suzuki",
        "Swift",
        [
            {
                "id": "timing-belt",
                "remove": True,
                "description": "Suzuki Swift (K-series engine) uses a timing chain.",
            },
        ],
    ),
    (
        "Suzuki",
        "Vitara",
        [
            {
                "id": "timing-belt",
                "remove": True,
                "description": "Suzuki Vitara (M-series engine) uses a timing chain.",
            },
        ],
    ),
    # ── Mazda ───────────────────────────────────────────────
    (
        "Mazda",
        "Mazda3",
        [
            {
                "id": "timing-belt",
                "remove": True,
                "description": "Mazda Skyactiv-G engines use timing chains.",
            },
            {
                "id": "spark-plugs",
                "interval_km": 120000,
                "description": "Mazda specifies iridium spark plugs every 120k km for Skyactiv engines.",
            },
        ],
    ),
    (
        "Mazda",
        "CX-5",
        [
            {
                "id": "timing-belt",
                "remove": True,
                "description": "Mazda Skyactiv-G engines use timing chains.",
            },
            {
                "id": "spark-plugs",
                "interval_km": 120000,
                "description": "Mazda specifies iridium spark plugs every 120k km for Skyactiv engines.",
            },
        ],
    ),
    # ── BMW ─────────────────────────────────────────────────
    ("BMW", "320", []),
    ("BMW", "X3", []),
    # ── Mercedes-Benz ───────────────────────────────────────
    ("Mercedes-Benz", "C200", []),
    ("Mercedes-Benz", "E200", []),
    # ── Audi ────────────────────────────────────────────────
    ("Audi", "A3", []),
    ("Audi", "Q5", []),
    # ── Citroën ─────────────────────────────────────────────
    ("Citroën", "C3", []),
    ("Citroën", "C4", []),
    # ── Jeep ────────────────────────────────────────────────
    ("Jeep", "Compass", []),
    ("Jeep", "Renegade", []),
    # ── Mitsubishi ──────────────────────────────────────────
    (
        "Mitsubishi",
        "ASX",
        [
            {
                "id": "timing-belt",
                "remove": True,
                "description": "Mitsubishi ASX (4B1 engine) uses a timing chain.",
            },
        ],
    ),
    ("Mitsubishi", "L200", []),
    # ── Subaru ──────────────────────────────────────────────
    (
        "Subaru",
        "Outback",
        [
            {
                "id": "timing-belt",
                "remove": True,
                "description": "Subaru Outback (FB, EZ engines) uses timing chains since ~2010.",
            },
        ],
    ),
    (
        "Subaru",
        "Forester",
        [
            {
                "id": "timing-belt",
                "remove": True,
                "description": "Subaru Forester (FB, EJ engines) uses timing chains since ~2010.",
            },
        ],
    ),
    # ── Volvo ───────────────────────────────────────────────
    (
        "Volvo",
        "XC60",
        [
            {
                "id": "timing-belt",
                "remove": True,
                "description": "Volvo XC60 (Drive-E engines) uses a timing chain.",
            },
        ],
    ),
    (
        "Volvo",
        "S60",
        [
            {
                "id": "timing-belt",
                "remove": True,
                "description": "Volvo S60 (Drive-E engines) uses a timing chain.",
            },
        ],
    ),
    # ── Chery ───────────────────────────────────────────────
    ("Chery", "Tiggo", []),
    ("Chery", "Arrizo", []),
    # ── Changan ─────────────────────────────────────────────
    ("Changan", "Alsvin", []),
    ("Changan", "CS35", []),
    # ── DFSK ────────────────────────────────────────────────
    ("DFSK", "Glory", []),
    ("DFSK", "C35", []),
    # ── JAC ─────────────────────────────────────────────────
    ("JAC", "S3", []),
    ("JAC", "T6", []),
    # ── Toyota (existing, re-creating for consistency) ──────
    (
        "Toyota",
        "Corolla",
        [
            {
                "id": "oil-change",
                "interval_km": 15000,
                "interval_months": 12,
                "description": "Toyota recommends 0W20 synthetic with 15k km intervals for most Corolla generations.",
            },
            {
                "id": "timing-belt",
                "remove": True,
                "description": "Corolla engines (2ZR, 1ZZ, 2ZZ) use timing chains, not belts.",
            },
            {
                "id": "spark-plugs",
                "interval_km": 100000,
                "description": "Iridium spark plugs last up to 100k km on most Corolla generations.",
            },
        ],
    ),
    ("Toyota", "Hilux", []),
    ("Toyota", "Yaris", []),
    # ── Volkswagen (existing, re-creating for consistency) ──
    (
        "Volkswagen",
        "Golf",
        [
            {
                "id": "timing-belt",
                "interval_km": 120000,
                "interval_months": 60,
                "description": "VW specifies timing belt at 120k km for most Golf generations. Replace water pump simultaneously.",
            },
        ],
        "vw-golf",
    ),
    ("Volkswagen", "Polo", []),
    ("Volkswagen", "Tiguan", []),
    # ── Honda (motorcycles) ────────────────────────────────
    ("Honda", "CB190", []),
    ("Honda", "XR190L", []),
    ("Honda", "NXR160 Bros", []),
    ("Honda", "CG160 Titan", []),
    # ── Yamaha ─────────────────────────────────────────────
    ("Yamaha", "YBR150 Factor", []),
    ("Yamaha", "XTZ150", []),
    ("Yamaha", "MT-15", []),
    # ── Suzuki ─────────────────────────────────────────────
    ("Suzuki", "GN125", []),
    ("Suzuki", "GSX-S150", []),
    ("Suzuki", "V-Strom 250", []),
    # ── Kawasaki ───────────────────────────────────────────
    ("Kawasaki", "Ninja 400", []),
    ("Kawasaki", "Versys 300", []),
    # ── Bajaj ──────────────────────────────────────────────
    ("Bajaj", "Rouser NS200", []),
    ("Bajaj", "Pulsar 160", []),
    # ── TVS ────────────────────────────────────────────────
    ("TVS", "Apache RTR 160", []),
    # ── Royal Enfield ──────────────────────────────────────
    ("Royal Enfield", "Classic 350", []),
    ("Royal Enfield", "Meteor 350", []),
    ("Royal Enfield", "Himalayan 450", []),
    # ── Benelli ─────────────────────────────────────────────
    ("Benelli", "TRK 502 X", []),
]


def make_id(make: str, model: str, custom_id: str | None = None) -> str:
    """Create a slug-style id from make and model, or use custom_id."""
    if custom_id:
        return custom_id
    s = f"{make}-{model}"
    return s.lower().replace(" ", "-").replace("ë", "e").replace("ñ", "n")


def make_path(make: str, model: str) -> Path:
    """Create the folder path for a make/model."""
    make_dir = make.lower().replace(" ", "-").replace("ë", "e").replace(
        "ñ", "n"
    )
    model_dir = model.lower().replace(" ", "-").replace("ë", "e").replace(
        "ñ", "n"
    )
    return TEMPLATES_DIR / make_dir / model_dir / "base.json"


def generate_templates():
    created = 0
    for entry in models:
        make, model, overrides = entry[0], entry[1], entry[2]
        custom_id = entry[3] if len(entry) > 3 else None
        path = make_path(make, model)
        template_id = make_id(make, model, custom_id)

        # Determine extends: combustion by default
        extends = ["_base/combustion.json"]

        data = {
            "id": template_id,
            "extends": extends,
            "meta": {
                "make": make,
                "model": model,
                "generation": "All",
                "years": None,
                "engine": None,
                "author": "abrahdev",
                "version": "1.0.0",
            },
            "maintenance_items": overrides,
        }

        write_json(path, data)
        created += 1

    print(f"\nTotal: {created} model templates created/updated.")


if __name__ == "__main__":
    generate_templates()
