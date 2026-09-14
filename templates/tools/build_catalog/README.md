# build_catalog

Compiles the `templates/data` JSON files into the catalog SQLite database
(`templates/karter-catalog.db`) consumed by the app.

## Usage

```bash
python templates/tools/build_catalog/build_catalog.py            # build the DB
python templates/tools/build_catalog/build_catalog.py --check-only          # validate without writing
python templates/tools/build_catalog/build_catalog.py --check-only --schema-check  # + JSON Schema validation
```

## What it does

- Resolves the template inheritance chains (`extends`).
- Flattens maintenance items, parts, OBD codes and related DTCs into SQLite tables.
- Validates schema and post-merge results; exits with a non-zero code on any error.

This step also creates the symlink `mobile/assets/catalog/karter-catalog.db`.
CI and the release workflow run it automatically.