# Karter maintenance templates

This directory is the source of truth for the vehicle maintenance data shipped
with the Karter mobile app. It is a self-contained, human-editable package:
fork it, add your vehicle, and open a pull request.

| Path | Purpose |
| :--- | :--- |
| `data/` | Vehicle templates, grouped by manufacturer, plus `_base/` fragments |
| `data/_base/` | Reusable base fragments (`car-common`, `car-combustion`, `car-diesel`, `car-electric`, `motorcycle-common`, `motorcycle-2t`, `motorcycle-4t`, `motorcycle-ev`) and `dtc.json` (the general OBD-II code set) |
| `i18n/` | Translations: `en.json` (generated from templates) plus `es.json`, `et.json`, `pt.json`, `de.json`, `ru.json`, `fr.json`, `pl.json`, `it.json`, `nl.json` |
| `schemas/template-v2.json` | JSON Schema that validates the template format |
| `index.json` | Generated manifest of every indexable vehicle template |
| `tools/` | One folder per generation/translation script, each with its own README (`build_catalog/`, `generate_index/`, `i18n_json/`, `import_dtc/`, `translate_i18n/`) |
| `NOTICE.md` | MIT attribution for the `dtc-database` (Wal33D) feeding the general OBD codes |

## Documentation

The full authoring guide (template format, `extends` semantics, required vs
optional fields, i18n, validation) lives in the docs site:

- **Authoring templates:** [`docs/docs/templates/authoring.md`](../docs/docs/templates/authoring.md)
- **Data & Template Pipeline** (JSON → SQLite catalog → app): [`docs/docs/templates/data-pipeline.md`](../docs/docs/templates/data-pipeline.md)

Published at <https://karter.abrah.dev/templates/authoring> and
<https://karter.abrah.dev/templates/data-pipeline>.

## Building the catalog

```bash
python templates/tools/generate_index/generate_index.py   # regenerate index.json
python templates/tools/i18n_json/i18n_json.py        # regenerate i18n/en.json
python templates/tools/build_catalog/build_catalog.py    # build templates/karter-catalog.db
```

Validation:

```bash
python templates/tools/build_catalog/build_catalog.py --check-only          # post-merge validation
python templates/tools/build_catalog/build_catalog.py --check-only --schema-check  # + JSON Schema (pip install -r tools/requirements.txt)
```