"""Shared loading of AI prompt templates from PROMPTS.md files."""


def load_prompt(file_path: str, **replacements) -> str:
    """Load a prompt from a markdown file and substitute placeholders.

    Args:
        file_path: Path to the PROMPTS.md file.
        **replacements: Placeholders to replace, e.g. load_prompt(f, language='en')
            replaces the literal ``{language}`` text.

    Returns:
        The prompt text with placeholders replaced.
    """
    with open(file_path, encoding="utf-8") as fh:
        content = fh.read()
    for key, value in replacements.items():
        content = content.replace("{" + key + "}", str(value))
    return content