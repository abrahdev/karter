"""AI-powered extraction of maintenance data from workshop manual text."""

import json
import re
import sys
import time

try:
    from openai import OpenAI
except ImportError:
    sys.exit("Missing dependency: run  pip install openai  first")

from rich.console import Console

console = Console()

MAX_RETRIES = 5
RETRY_BASE = 3


EXTRACTION_PROMPT = """You are an expert automotive technician and data extractor. 
Your task is to extract structured maintenance data from a workshop manual PDF.

Extract the following information and return it as valid JSON:

{
  "id": "vehicle-slug (e.g., toyota-corolla-e210)",
  "meta": {
    "make": "Vehicle make (e.g., Toyota)",
    "model": "Vehicle model (e.g., Corolla)",
    "generation": "Generation/chassis code if available (e.g., E210)",
    "years": [start_year, end_year_or_null],
    "engine": {
      "code": "Engine code if available",
      "fuel": "gasoline|diesel|lpg|cng|hydrogen|ethanol",
      "powertrain": "combustion|hybrid|plugin-hybrid|electric",
      "displacement_cc": displacement_in_cc,
      "power_hp": power_in_hp
    },
    "market": ["EU", "US", etc.],
    "author": "AI-generated",
    "version": "1.0.0",
    "sources": ["Source URL or description"]
  },
  "parts": [
    {
      "id": "part-id (e.g., oil-filter)",
      "name": "Part name",
      "i18n_key": "translation_key",
      "oem_number": "OEM reference if available",
      "quantity": 1,
      "unit": "unit|set|L|ml|g|kg|kit|can|m",
      "description": "Part description"
    }
  ],
  "maintenance_items": [
    {
      "id": "item-id (e.g., oil-change)",
      "interval_km": interval_in_km,
      "interval_months": interval_in_months,
      "label": "Maintenance task name",
      "i18n_key": "translation_key",
      "description": "Task description",
      "parts": [
        {"part_id": "part-id", "quantity": 1}
      ]
    }
  ],
  "obd_dtc_definitions": [
    {
      "code": "P0171",
      "scope": "standard|manufacturer",
      "description": "Code description",
      "desc_i18n_key": "translation_key",
      "related_maintenance": ["maintenance-item-id"],
      "related_parts": ["part-id"]
    }
  ]
}

Rules:
1. Extract ONLY data that is explicitly mentioned in the manual text.
2. Use realistic intervals based on automotive standards if not specified.
3. Generate valid slug IDs (lowercase, hyphens, no spaces).
4. Generate i18n_key as snake_case (e.g., part_oil_filter, seed_interval_oil_change).
5. If engine info is not available, omit the engine object.
6. If years are not available, use [2020, null] as placeholder.
7. Return ONLY valid JSON, no explanations or markdown.
8. Be conservative: if unsure about a value, omit it rather than guess.
9. Focus on common maintenance: oil change, filters, brakes, spark plugs, timing belt, etc.
10. Extract DTC codes only if explicitly listed in the manual.

Language: {language}
"""


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
    system_prompt = EXTRACTION_PROMPT.format(language=language)

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
