"""Schema validation for extracted template data."""

import json
import os
import sys
from typing import Any

try:
    from jsonschema import Draft7Validator, ValidationError
except ImportError:
    sys.exit("Missing dependency: run  pip install jsonschema  first")

from rich.console import Console

console = Console()

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
SCHEMA_PATH = os.path.join(REPO_ROOT, "templates", "schemas", "template-v2.json")


def load_schema() -> dict:
    """Load the template schema."""
    with open(SCHEMA_PATH, encoding="utf-8") as fh:
        return json.load(fh)


def validate_template(data: dict) -> list[dict[str, Any]]:
    """Validate extracted data against the template schema.

    Args:
        data: Extracted template data

    Returns:
        List of validation errors (empty if valid)
    """
    schema = load_schema()
    validator = Draft7Validator(schema)

    errors = []
    for error in validator.iter_errors(data):
        path = ".".join(str(p) for p in error.absolute_path) if error.absolute_path else "(root)"
        errors.append({
            "path": path,
            "message": error.message,
            "validator": error.validator,
        })

    return errors


def _duplicates(values) -> list[str]:
    """Return sorted values that appear more than once (None values skipped)."""
    seen = set()
    dupes = set()
    for value in values:
        if value is None:
            continue
        if value in seen:
            dupes.add(value)
        seen.add(value)
    return sorted(dupes)


def validate_post_merge(data: dict) -> list[dict[str, Any]]:
    """Perform post-merge validation (business logic checks).

    These checks go beyond JSON Schema and verify:
    - Unique IDs within arrays
    - Required fields after merge
    - Year ordering
    - Interval values
    """
    errors = []

    # Check unique part IDs
    if "parts" in data:
        dupes = _duplicates(p.get("id") for p in data["parts"])
        if dupes:
            errors.append({
                "path": "parts",
                "message": f"Duplicate part IDs: {set(dupes)}",
                "validator": "uniqueItems",
            })

    # Check unique maintenance item IDs
    if "maintenance_items" in data:
        dupes = _duplicates(i.get("id") for i in data["maintenance_items"])
        if dupes:
            errors.append({
                "path": "maintenance_items",
                "message": f"Duplicate maintenance item IDs: {set(dupes)}",
                "validator": "uniqueItems",
            })

    # Check unique DTC codes
    if "obd_dtc_definitions" in data:
        dupes = _duplicates(d.get("code") for d in data["obd_dtc_definitions"])
        if dupes:
            errors.append({
                "path": "obd_dtc_definitions",
                "message": f"Duplicate DTC codes: {set(dupes)}",
                "validator": "uniqueItems",
            })

    # Check year ordering
    if "meta" in data and "years" in data["meta"]:
        years = data["meta"]["years"]
        if len(years) == 2 and years[0] is not None and years[1] is not None:
            if years[0] > years[1]:
                errors.append({
                    "path": "meta.years",
                    "message": f"Start year ({years[0]}) > end year ({years[1]})",
                    "validator": "yearOrder",
                })

    # Check maintenance item intervals
    if "maintenance_items" in data:
        for item in data["maintenance_items"]:
            km = item.get("interval_km")
            if km is None or km < 1:
                errors.append({
                    "path": f"maintenance_items[{item.get('id', '?')}].interval_km",
                    "message": "interval_km is required and must be >= 1 (the catalog requires it)",
                    "validator": "minimum",
                })
            months = item.get("interval_months")
            if months is not None and months < 1:
                errors.append({
                    "path": f"maintenance_items[{item.get('id', '?')}].interval_months",
                    "message": "interval_months must be >= 1",
                    "validator": "minimum",
                })

    return errors


def validate_all(data: dict) -> tuple[bool, list[dict[str, Any]]]:
    """Run all validations (schema + post-merge).

    Returns:
        Tuple of (is_valid, errors)
    """
    all_errors = []

    # Schema validation
    schema_errors = validate_template(data)
    all_errors.extend(schema_errors)

    # Post-merge validation
    post_merge_errors = validate_post_merge(data)
    all_errors.extend(post_merge_errors)

    return len(all_errors) == 0, all_errors


def print_errors(errors: list[dict[str, Any]]) -> None:
    """Print validation errors in a readable format."""
    if not errors:
        console.print("[green]✓ All validations passed[/]")
        return

    console.print(f"\n[red]✗ {len(errors)} validation error(s):[/]")
    for i, error in enumerate(errors, 1):
        console.print(f"  [bold]{i}.[/] [yellow]{error['path']}[/]")
        console.print(f"     {error['message']}")
        console.print(f"     [dim]({error['validator']})[/]")
