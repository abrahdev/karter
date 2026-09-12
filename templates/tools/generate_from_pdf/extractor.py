"""AI-powered extraction of maintenance data from workshop manual text."""

import json
import os
import re
import sys
import time

try:
    from openai import OpenAI
except ImportError:
    sys.exit("Missing dependency: run  pip install openai  first")

from rich.console import Console

sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))
from _shared import load_prompt

console = Console()

MAX_RETRIES = 5
RETRY_BASE = 3

PROMPTS_FILE = os.path.join(os.path.dirname(__file__), "PROMPTS.md")


def extract_with_ai(
    client: OpenAI,
    model: str,
    pdf_text: str,
    language: str,
    max_tokens: int = 4000,
) -> dict:
    """Extract maintenance data from PDF text using AI.

    Args:
        client: OpenAI client instance
        model: Model ID to use
        pdf_text: Extracted text from PDF
        language: Detected or specified language
        max_tokens: Maximum tokens for response

    Returns:
        Extracted data as dictionary
    """
    system_prompt = load_prompt(PROMPTS_FILE, language=language)

    # Truncate text if too long (most models have context limits)
    max_chars = 100000  # ~25k tokens
    if len(pdf_text) > max_chars:
        pdf_text = pdf_text[:max_chars] + "\n\n[TRUNCATED]"
        console.print("[yellow]⚠ PDF text truncated due to length[/]")

    last_error = None
    for attempt in range(MAX_RETRIES):
        try:
            console.print(f"[dim]  Attempt {attempt + 1}/{MAX_RETRIES}...[/]")

            resp = client.chat.completions.create(
                model=model,
                temperature=0.2,
                max_tokens=max_tokens,
                response_format={"type": "json_object"},
                messages=[
                    {"role": "system", "content": system_prompt},
                    {
                        "role": "user",
                        "content": f"Extract maintenance data from this workshop manual:\n\n{pdf_text}",
                    },
                ],
            )

            content = resp.choices[0].message.content
            data = json.loads(content)

            # Basic validation
            if "id" not in data or "meta" not in data:
                raise ValueError("Missing required fields: id, meta")

            return data

        except json.JSONDecodeError as e:
            last_error = e
            console.print(f"[yellow]  JSON parse error: {e}[/]")
        except Exception as e:
            last_error = e
            console.print(f"[yellow]  Error: {type(e).__name__}: {e}[/]")

        if attempt < MAX_RETRIES - 1:
            wait = RETRY_BASE * (2**attempt)
            console.print(f"[dim]  Retrying in {wait}s...[/]")
            time.sleep(wait)

    raise RuntimeError(f"Extraction failed after {MAX_RETRIES} attempts: {last_error}")


def clean_extracted_data(data: dict) -> dict:
    """Clean and normalize extracted data.

    - Ensure IDs are valid slugs
    - Remove empty arrays
    - Normalize field names
    """
    # Clean vehicle ID
    if "id" in data:
        data["id"] = re.sub(r"[^a-z0-9\-]", "-", data["id"].lower())
        data["id"] = re.sub(r"-+", "-", data["id"]).strip("-")

    # Clean part IDs
    if "parts" in data:
        for part in data["parts"]:
            if "id" in part:
                part["id"] = re.sub(r"[^a-z0-9\-]", "-", part["id"].lower())
                part["id"] = re.sub(r"-+", "-", part["id"]).strip("-")

    # Clean maintenance item IDs
    if "maintenance_items" in data:
        for item in data["maintenance_items"]:
            if "id" in item:
                item["id"] = re.sub(r"[^a-z0-9\-]", "-", item["id"].lower())
                item["id"] = re.sub(r"-+", "-", item["id"]).strip("-")

    # Remove empty arrays
    for key in ["parts", "maintenance_items", "obd_dtc_definitions"]:
        if key in data and not data[key]:
            del data[key]

    return data
