# generate_index

Genera `templates/index.json`, el índice que lista todos los templates
disponibles (vehículos) que la app descarga desde el repositorio.

## Uso

```bash
python templates/tools/generate_index/generate_index.py
```

## Qué hace

- Escanea los `*.json` bajo `templates/data/`.
- Construye un índice plano con los metadatos de cada template.
- Escribe `templates/index.json`.

Es un paso previo a `build_catalog`. CI lo ejecuta cuando cambian los JSON
de templates.