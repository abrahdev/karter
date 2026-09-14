# translate_i18n

Interactive tool to translate `templates/i18n/en.json` into other languages
using an AI model, and to keep the catalog up to date.

## Usage

```bash
pip install -r templates/tools/requirements.txt
python templates/tools/translate_i18n/translate_i18n.py
```

## Features

- **Provider**: curated list of OpenAI-compatible gateways (OpenCode Go,
  DeepSeek, OpenAI, Anthropic, Groq, Mistral, OpenRouter) or a custom endpoint.
- **Model**: dynamic selection of the models available from the provider,
  with their price per million tokens.
- **Languages**: one or several of the existing `.json` files, or a new code.
- **Modes**:
  - `Full redo` — retranslate everything.
  - `Complete missing keys` — fill only the keys absent from a language file.
  - `Validate only` — check parity and divergence without calling the API.
- **API key**: read from `templates/tools/.env`, from an environment variable,
  or pasted on the fly (optionally saved).
- **Cost estimate** based on the keys that are actually pending, with a live
  progress bar.
- **Checkpoints**: if interrupted (Ctrl+C), it resumes on the next run.

## Requirements

Python 3 + the packages in `templates/tools/requirements.txt` (`openai`,
`rich`).

The API key is never committed to the repository (`.env` is in `.gitignore`).