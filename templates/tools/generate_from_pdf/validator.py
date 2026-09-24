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
DATA_ROOT = os.path.join(REPO_ROOT, "templates", "data")
I18N_EN = os.path.join(REPO_ROOT, "templates", "i18n", "en.json")

sys.path.insert(0, os.path.join(REPO_ROOT, "templates", "tools", "build_catalog"))
import build_catalog as bc


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


def _resolve_with_delta(
    data: dict,
    base_path: str | None,
    brand_dtc_path: str | None,
) -> "bc.Resolution":
    """Resolve base + brand dtc (on disk) and apply the delta in memory."""
    cache: dict = {}
    memo: dict = {}
    res = bc.Resolution()
    for ext in (base_path, brand_dtc_path):
        if not ext:
            continue
        ancestor = bc.resolve(ext, DATA_ROOT, cache, set(), memo)
        bc._apply_map(res.items, ancestor.items, keep_existing=False)
        bc._apply_map(res.parts, ancestor.parts, keep_existing=False)
        bc._apply_map(res.dtcs, ancestor.dtcs, keep_existing=False)
        res.inherits_general = res.inherits_general or ancestor.inherits_general

    bc._apply_template_items(res.items, data.get("maintenance_items") or [])
    bc._apply_template_parts(res.parts, data.get("parts") or [])
    bc._apply_template_dtcs(res.dtcs, data.get("obd_dtc_definitions") or [])
    return res


def _load_i18n_en() -> dict:
    try:
        with open(I18N_EN, encoding="utf-8") as fh:
            return json.load(fh)
    except OSError:
        return {}


def validate_merged(
    data: dict,
    base_path: str | None = None,
    brand_dtc_path: str | None = None,
) -> list[str]:
    """Validate the MERGED result of base + brand dtc + delta.

    Resolves the on-disk base and brand dtc templates, applies the in-memory
    delta on top, then runs the same post-merge checks as the catalog build
    (interval_km, labels, descriptions, part references). Read-only: it never
    writes to disk or regenerates anything.

    Args:
        data: The generated delta template (may be a standalone template when
            both base_path and brand_dtc_path are None).
        base_path: Leaf base path relative to templates/data/ (e.g.
            "_base/motorcycle-4t.json"), or None for standalone output.
        brand_dtc_path: Brand dtc path relative to templates/data/ (e.g.
            "bmw/dtc.json"), or None when no brand dtc applies.

    Returns:
        List of error strings (empty when valid).
    """
    res = _resolve_with_delta(data, base_path, brand_dtc_path)
    i18n_en = _load_i18n_en()

    errors: list[str] = []
    bc.validate(res, "<generated>", i18n_en, errors)

    for item in res.items.values():
        for part_id in item.parts:
            if part_id not in res.parts:
                errors.append(
                    f"item {item.id!r} references unknown part {part_id!r}"
                )

    return errors


def build_merged_view(
    data: dict,
    base_path: str | None = None,
    brand_dtc_path: str | None = None,
) -> dict:
    """Build the fully-resolved view (base + brand dtc + delta) for review.

    Returns a dict shaped like a template (meta, maintenance_items, parts,
    obd_dtc_definitions) where inherited defaults are applied and labels /
    descriptions are resolved via the base or en.json.
    """
    res = _resolve_with_delta(data, base_path, brand_dtc_path)
    i18n_en = _load_i18n_en()

    def resolved(value, i18n_key, fallback=""):
        if i18n_key and i18n_en.get(i18n_key):
            return i18n_en[i18n_key]
        if value:
            return value
        return fallback

    return {
        "meta": data.get("meta", {}),
        "maintenance_items": [
            {
                "id": item.id,
                "label": resolved(item.label, item.i18n_key, item.id),
                "interval_km": item.interval_km,
                "interval_months": item.interval_months,
                "description": resolved(item.description, item.desc_i18n_key, ""),
            }
            for item in res.items.values()
        ],
        "parts": [
            {
                "id": part.id,
                "name": resolved(part.name, part.i18n_key, part.id),
                "quantity": part.quantity,
                "unit": part.unit,
            }
            for part in res.parts.values()
        ],
        "obd_dtc_definitions": [
            {
                "code": dtc.code,
                "description": resolved(dtc.description, dtc.desc_i18n_key, dtc.code),
            }
            for dtc in res.dtcs.values()
        ],
    }


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
