# import_dtc

Importa definiciones de códigos de diagnóstico OBD-II (DTC) a los templates
en `templates/data`, normalmente desde una fuente externa.

## Uso

```bash
python templates/tools/import_dtc/import_dtc.py
```

## Qué hace

- Añade definiciones `obd_dtc_definitions` a los templates base.
- Asigna `desc_i18n_key` para cada código, que luego alimenta
  `templates/i18n/en.json` (vía `i18n_json/`).

Es una herramienta de ingestión puntual: no se ejecuta en CI.