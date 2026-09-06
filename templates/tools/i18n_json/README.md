# i18n_json

Genera (o resincroniza) `templates/i18n/en.json`, el diccionario de cadenas
en inglés que usan los templates (`i18n_key` / `desc_i18n_key`).

## Uso

```bash
python templates/tools/i18n_json/i18n_json.py            # regenerar en.json
python templates/tools/i18n_json/i18n_json.py --check    # reportar diferencias sin escribir
```

## Qué hace

- Recorre todos los templates y recoge las cadenas por defecto (labels,
  nombres de parts y descripciones DTC).
- Los archivos `_base/` tienen prioridad cuando varias marcas reutilizan la
  misma clave.
- Conserva claves existentes que ningún template referencie (no se pierden
  entradas curadas).

Las traducciones a otros idiomas viven en `templates/i18n/<lang>.json` y se
gestionan con `translate_i18n/`.