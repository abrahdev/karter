# build_catalog

Compila los JSON de `templates/data` en la base de datos SQLite del catálogo
(`templates/karter-catalog.db`) que consume la app.

## Uso

```bash
python templates/tools/build_catalog/build_catalog.py            # construir la DB
python templates/tools/build_catalog/build_catalog.py --check-only          # validar sin escribir
python templates/tools/build_catalog/build_catalog.py --check-only --schema-check  # + validar JSON Schema
```

## Qué hace

- Resuelve las cadenas de herencia (`extends`) de los templates.
- Aplana maintenance items, parts, OBD codes y DTC relacionados en tablas SQLite.
- Valida esquema y resultados post-merge; falla con código distinto de cero si hay errores.

Este paso también crea el symlink `mobile/assets/catalog/karter-catalog.db`.
CI y el workflow de release lo ejecutan automáticamente.