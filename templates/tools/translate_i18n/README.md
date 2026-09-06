# translate_i18n

Herramienta interactiva para traducir `templates/i18n/en.json` a otros
idiomas mediante un modelo de IA, y mantener al día el catálogo.

## Uso

```bash
pip install -r templates/tools/requirements.txt
python templates/tools/translate_i18n/translate_i18n.py
```

## Qué ofrece

- **Provider**: lista de gateways OpenAI-compatible (OpenCode Go, DeepSeek,
  OpenAI, Anthropic, Groq, Mistral, OpenRouter) o endpoint custom.
- **Modelo**: selección dinámica de los modelos disponibles en el provider,
  con su precio por millón de tokens.
- **Idiomas**: uno o varios de los `.json` existentes, o un código nuevo.
- **Modos**:
  - `Full redo` — retraduce todo.
  - `Complete missing keys` — rellena solo las claves ausentes.
  - `Validate only` — revisa paridad y divergencia sin llamar a la API.
- **API key**: la toma de `translate_i18n/.env`, de una variable de entorno,
  o la pegas en el momento (opcional guardarla).
- **Estimación de coste** sobre las claves realmente pendientes, y barra de
  progreso en vivo.
- **Checkpoints**: si se interrumpe (Ctrl+C), se reanuda al re-ejecutar.

## Requisitos

Python 3 + paquetes de `templates/tools/requirements.txt` (`openai`, `rich`).

La API key nunca se sube al repositorio (`.env` está en `.gitignore`).