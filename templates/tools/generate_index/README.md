# generate_index

Generates `templates/index.json`, the index that lists all available
templates (vehicles) that the app downloads from the repository.

## Usage

```bash
python templates/tools/generate_index/generate_index.py
```

## What it does

- Scans the `*.json` files under `templates/data/`.
- Builds a flat index with each template's metadata.
- Writes `templates/index.json`.

It is a prerequisite for `build_catalog`. CI runs it when the template JSON
files change.