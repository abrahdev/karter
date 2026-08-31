---
sidebar_position: 1
title: Authoring templates
sidebar_custom_props:
  icon: '📝'
---

# Authoring templates

This guide explains how to author or edit a vehicle template. The source of
truth lives in the [`templates/`](https://github.com/abrahdev/karter/tree/main/templates)
directory of the repository — a self-contained, human-editable package that can
be forked by communities to create their own template repos.

| Path | Purpose |
| :--- | :--- |
| `data/` | Vehicle templates, grouped by manufacturer, plus `_base/` fragments |
| `data/_base/` | Reusable base fragments (`car-common`, `car-combustion`, `car-diesel`, `car-electric`, `motorcycle-common`, `motorcycle-2t`, `motorcycle-4t`, `motorcycle-ev`) and `dtc.json` (the general OBD-II code set) |
| `i18n/` | Translations: `en.json` (generated from templates), `es.json` / `et.json` (curated) |
| `schemas/template-v2.json` | JSON Schema that validates the template format |
| `index.json` | Generated manifest of every indexable vehicle template |
| `tools/` | Generation and validation scripts |
| `NOTICE.md` | MIT attribution for the `dtc-database` (Wal33D) feeding the general OBD codes |

## Authoring a template

A template is a single JSON file describing one vehicle (or a shared base
fragment). It declares metadata, optional `extends`, and the three entity
sections. Entities are **merged by id** along the `extends` chain and can be
**overridden** (re-declare the same id) or **removed** (`"remove": true`).

```json
{
  "id": "toyota-corolla",
  "extends": ["_base/car-common.json", "_base/car-combustion.json"],
  "meta": {
    "make": "Toyota",
    "model": "Corolla",
    "generation": "E210",
    "years": [2019, 2024],
    "engine": { "code": "M20A-FKS", "fuel": "gasoline", "displacement_cc": 1987 },
    "author": "abrahdev",
    "version": "1.0.0"
  },
  "parts": [
    { "id": "oil-filter", "name": "Oil filter", "oem_number": "90915-YZZE3", "quantity": 1 }
  ],
  "maintenance_items": [
    {
      "id": "oil-change",
      "label": "Oil change",
      "interval_km": 15000,
      "interval_months": 12,
      "parts": [{ "part_id": "oil-filter", "quantity": 1 }]
    }
  ],
  "obd_dtc_definitions": [
    { "code": "P1100", "scope": "manufacturer", "related_maintenance": ["oil-change"] }
  ]
}
```

### Directory layout

```
templates/data/
  _base/                    # shared fragments, extended by everything
  <make>/                   # one folder per manufacturer (lowercase slug)
    <model>/                # one folder per model
      base.json             # model-level defaults; may be empty (placeholder)
      <generation>-<engine>.json   # concrete vehicle templates
    dtc.json                # optional manufacturer-specific DTCs for the make
```

Concrete templates go in `data/<make>/<model>/`. The `extends` paths are
relative to `templates/data/` and must end in `.json`.

### Required vs optional fields

Raw-file rules (enforced by the JSON Schema); merge-time rules are enforced by
`build_catalog.py` after the `extends` chain resolves.

- **`meta`** (required): `make`, `model`, `author`, `version` are required.
  `years` is `[start, end]` where `end` may be `null` (still in production);
  `start <= end`.
- **`parts[]`**: `id` always required. `name` or `i18n_key` is required for
  parts that are *new* (not inherited from a parent) — validated after merge.
  `quantity` must be greater than `0`.
- **`maintenance_items[]`**: `id` always required. New items must define
  `interval_km` and a `label`/`i18n_key` (validated after merge). `interval_km`
  and `interval_months` must be >= 1. An empty array is allowed in per-model
  `base.json` placeholder fragments.
- **`obd_dtc_definitions[]`**: `code` and `scope` (`standard` | `manufacturer`)
  always required. New codes must define `description`/`desc_i18n_key`
  (validated after merge). Codes are formatted `^[PCBU][0-9A-F]{4}$` (e.g.
  `P0171`, `U0100`).

Ids must be unique within their array, and `meta.years` must be ordered — both
are enforced by `build_catalog.py --schema-check`.

### Translations (i18n)

Every user-facing string can be localized. Declare the English text in the
template and reference it through a key:

- `i18n_key` — label of a part or maintenance item
- `desc_i18n_key` — description of a maintenance item or DTC
- `meta.author` / `meta.sources` are free text and are not localized

Run `python templates/tools/i18n_json.py` to (re)generate `i18n/en.json` from
the templates. `es.json` and `et.json` are curated translations (via Weblate);
leave them alone unless you speak the language.

### Validating your template

```bash
# Post-merge validation (interval_km/label/description present after inheritance)
python templates/tools/build_catalog.py --check-only

# Also validate every raw file against schemas/template-v2.json
# (needs: pip install -r templates/tools/requirements.txt)
python templates/tools/build_catalog.py --check-only --schema-check
```

CI runs the schema check on every pull request. Any validation error exits
non-zero and fails the build.

## References

- JSON Schema: [`schemas/template-v2.json`](https://github.com/abrahdev/karter/blob/main/templates/schemas/template-v2.json)
- Pipeline details: see [Data & Template Pipeline](./data-pipeline)