# i18n_json

Generates (or re-syncs) `templates/i18n/en.json`, the English string
dictionary used by the templates (`i18n_key` / `desc_i18n_key`).

## Usage

```bash
python templates/tools/i18n_json/i18n_json.py            # regenerate en.json
python templates/tools/i18n_json/i18n_json.py --check    # report drift without writing
```

## What it does

- Walks all templates and collects the default strings (labels, part names
  and DTC descriptions).
- `_base/` files take precedence when several brands reuse the same key.
- Keeps existing keys that no template references (curated entries are never
  lost).

Translations for other languages live in `templates/i18n/<lang>.json` and
are managed with `translate_i18n/`.