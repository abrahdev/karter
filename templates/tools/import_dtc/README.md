# import_dtc

Imports OBD-II diagnostic trouble code (DTC) definitions into the templates
under `templates/data`, usually from an external source.

## Usage

```bash
python templates/tools/import_dtc/import_dtc.py
```

## What it does

- Adds `obd_dtc_definitions` to the base templates.
- Assigns a `desc_i18n_key` for each code, which later feeds
  `templates/i18n/en.json` (via `i18n_json/`).

It is a one-off ingestion tool: it is not run in CI.