#!/usr/bin/env python3
"""Generate Karter template from workshop manual PDF using AI.

Interactive CLI that:
1. Reads a PDF workshop manual
2. Extracts text and detects language
3. Uses AI to extract structured maintenance data
4. Shows extracted data for review
5. Validates against template schema
6. Saves to templates/data/

Usage:
  python3 templates/tools/generate_from_pdf/generate_from_pdf.py
"""

import json
import os
import sys

# Import shared utilities
sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))
from _shared import (
    BACK,
    STYLE_TITLE,
    ask,
    confirm,
    confirm2,
    create_client,
    get_api_key,
    make_progress,
    pick_option,
    print_header,
    print_title,
    run_cli,
    select_model,
    select_path,
    select_provider,
)
from _shared.ui import console

from extractor import clean_extracted_data, extract_with_ai
from pdf_reader import PDFReader
from planner import plan as plan_template, validate_plan as validate_plan_errors
from validator import build_merged_view, print_errors, validate_all, validate_merged

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
DATA_DIR = os.path.join(REPO_ROOT, "templates", "data")

# Review menu actions that edit a single section of the extracted data.
SECTION_ACTIONS = {
    "edit_meta": "meta",
    "edit_items": "maintenance_items",
    "edit_parts": "parts",
    "edit_dtc": "obd_dtc_definitions",
}


def select_input_mode() -> str:
    """Select whether to process a single file or a folder."""
    return pick_option(
        "Select input mode",
        [
            ("file", "Single PDF file"),
            ("folder", "Folder with multiple manuals (batch)"),
        ],
        default_index=1,
    )


def select_pdf() -> str | None:
    """Interactive PDF file selection with retry loop.

    Returns:
        Valid file path, or None if the user wants to go back
        to the input mode selection.
    """
    return select_path(kind="file")


def select_folder() -> str | None:
    """Interactive folder selection with retry loop.

    Returns:
        Valid folder path, or None if the user wants to go back
        to the input mode selection.
    """
    return select_path(kind="folder")


def list_pdfs_in_folder(folder_path: str) -> list[str]:
    """List all PDF files in a folder."""
    pdfs = []
    for root, dirs, files in os.walk(folder_path):
        for file in files:
            if file.lower().endswith(".pdf"):
                pdfs.append(os.path.join(root, file))
    return sorted(pdfs)


def select_language(detected: str) -> str:
    """Let user confirm or change detected language."""
    console.print(f"\n[bold]Detected language:[/] {detected}")
    options = [
        ("en", "English"),
        ("es", "Spanish"),
        ("de", "German"),
        ("fr", "French"),
        ("it", "Italian"),
        ("pt", "Portuguese"),
        ("other", "Other"),
    ]
    pick = pick_option("Confirm or change language", options, default_index=1)
    if pick is BACK:
        return BACK
    if pick == "other":
        code = ask("Language code (e.g., sv, nl)")
        if code is BACK:
            return BACK
        return code
    return pick


def show_extracted_data(data: dict) -> None:
    """Display extracted data in a readable format."""
    console.print("\n" + "=" * 60)
    print_title("EXTRACTED DATA")
    console.print("=" * 60 + "\n")

    # Vehicle info
    meta = data.get("meta", {})
    console.print(f"[bold]Vehicle:[/] {meta.get('make', '?')} {meta.get('model', '?')}")
    if meta.get("generation"):
        console.print(f"[bold]Generation:[/] {meta['generation']}")
    if meta.get("years"):
        years = meta["years"]
        year_str = f"{years[0]}-{years[1] if years[1] else 'present'}"
        console.print(f"[bold]Years:[/] {year_str}")

    # Engine info
    engine = meta.get("engine", {})
    if engine:
        engine_parts = []
        if engine.get("code"):
            engine_parts.append(f"Code: {engine['code']}")
        if engine.get("displacement_cc"):
            engine_parts.append(f"{engine['displacement_cc']}cc")
        if engine.get("power_hp"):
            engine_parts.append(f"{engine['power_hp']}HP")
        if engine.get("fuel"):
            engine_parts.append(engine["fuel"])
        if engine_parts:
            console.print(f"[bold]Engine:[/] {', '.join(engine_parts)}")

    # Maintenance items
    items = data.get("maintenance_items", [])
    if items:
        console.print(f"\n[bold]Maintenance Items ({len(items)}):[/]")
        for item in items:
            label = item.get("label", item.get("id", "?"))
            interval = []
            if item.get("interval_km"):
                interval.append(f"{item['interval_km']:,} km")
            if item.get("interval_months"):
                interval.append(f"{item['interval_months']} months")
            interval_str = " / ".join(interval) if interval else "no interval"
            console.print(f"  • {label}: {interval_str}")

    # Parts
    parts = data.get("parts", [])
    if parts:
        console.print(f"\n[bold]Parts ({len(parts)}):[/]")
        for part in parts:
            name = part.get("name", part.get("id", "?"))
            qty = part.get("quantity", 1)
            unit = part.get("unit", "unit")
            console.print(f"  • {name}: {qty} {unit}")

    # DTC codes
    dtcs = data.get("obd_dtc_definitions", [])
    if dtcs:
        console.print(f"\n[bold]DTC Codes ({len(dtcs)}):[/]")
        for dtc in dtcs:
            code = dtc.get("code", "?")
            desc = dtc.get("description", "")
            console.print(f"  • {code}: {desc}")

    console.print("\n" + "=" * 60 + "\n")


def edit_section(data: dict, section: str) -> dict:
    """Interactive editor for a specific section."""
    console.print(f"\n[bold]Editing {section}[/]")
    console.print("[dim]Enter JSON to replace (or press Enter to keep current)[/]")

    current = json.dumps(data.get(section, {} if section == "meta" else []), indent=2)
    console.print(f"\n[yellow]Current value:[/]\n{current}\n")

    new_value = ask("New value (JSON)")
    if new_value is BACK:
        return data
    if new_value:
        try:
            data[section] = json.loads(new_value)
            console.print("[green]✓ Updated[/]")
        except json.JSONDecodeError as e:
            console.print(f"[red]✗ Invalid JSON: {e}[/]")

    return data


def show_plan(plan: dict) -> None:
    """Display the phase-1 plan for confirmation."""
    from rich.panel import Panel

    base = plan.get("base") or "(standalone)"
    console.print(
        Panel(
            f"[bold]Make:[/] {plan.get('make', '?')}  "
            f"[bold]Model:[/] {plan.get('model', '?')}\n"
            f"[bold]Base:[/] {base}\n"
            f"[bold]Target:[/] {plan.get('target_path', '?')}\n"
            f"[bold]Duplicate:[/] {plan.get('duplicate', False)}  "
            f"[bold]Overwrite:[/] {plan.get('overwrite', False)}\n"
            f"[dim]{plan.get('notes', '')}[/]",
            title="Plan",
            border_style="yellow",
        )
    )


def apply_extends(data: dict, plan: dict) -> None:
    """Add the extends chain to the generated delta (brand dtc is forced)."""
    if plan.get("base"):
        make_slug = plan["target_path"].split("/")[0]
        data["extends"] = [plan["base"], f"{make_slug}/dtc.json"]
    else:
        data.pop("extends", None)


def write_template(plan: dict, data: dict) -> str:
    """Write the generated template to the plan's target path.

    Returns:
        The saved absolute file path.
    """
    from planner import _data_path

    full = _data_path(plan["target_path"])
    if full is None:
        raise ValueError(f"unsafe target path: {plan['target_path']!r}")
    os.makedirs(os.path.dirname(full), exist_ok=True)
    with open(full, "w", encoding="utf-8") as fh:
        json.dump(data, fh, ensure_ascii=False, indent=2)
    return full


def extract_pdf_text_and_ai(
    pdf_path: str,
    provider: dict,
    api_key: str,
    client,
    language: str,
) -> tuple[dict, str, dict]:
    """Read the PDF text, run phase-1 planning and phase-2 extraction.

    Returns:
        (data, raw_content, plan) tuple.
    """
    console.print(f"\n[bold white]Processing:[/] {os.path.basename(pdf_path)}")

    reader = PDFReader(pdf_path)
    page_count = reader.get_page_count()
    console.print(f"[dim]✓ PDF loaded: {page_count} pages[/]")

    console.print("\n[bold]Extracting text from PDF...[/]")
    progress = make_progress()
    with progress:
        task = progress.add_task("Reading pages", total=page_count)
        pdf_text = reader.extract_text()
        progress.update(task, completed=page_count)

    console.print(f"[green]✓ Extracted {len(pdf_text):,} characters[/]")

    if confirm("View extracted manual text before sending to AI?", default="n") is True:
        with console.pager():
            console.print(pdf_text)

    console.print("\n[bold]Phase 1: planning (choosing base and path)...[/]")
    plan = plan_template(client, provider["model"], pdf_text, language)
    plan_errors = validate_plan_errors(plan)
    if plan_errors:
        console.print(f"[red]✗ Invalid plan: {', '.join(plan_errors)}[/]")
        raise RuntimeError(f"invalid plan: {', '.join(plan_errors)}")
    show_plan(plan)
    if confirm("Use this plan?") is not True:
        raise KeyboardInterrupt("Plan not confirmed")

    base = None
    if plan.get("base"):
        from planner import resolved_base

        base = resolved_base(plan["base"])

    console.print("\n[bold]Phase 2: analyzing with AI...[/]")
    console.print("[dim]  Streaming the response below; large manuals can take 1-3 minutes.[/]")
    data, raw = extract_with_ai(client, provider["model"], pdf_text, language, base=base)
    console.print("[green]✓ Extraction complete[/]")
    data = clean_extracted_data(data)
    apply_extends(data, plan)
    return data, raw, plan


def review_pdf(data: dict, raw: str, plan: dict) -> str | object:
    """Show the merged result and let the user review it.

    Displays the fully-resolved view (base + brand dtc + delta) so inherited
    defaults are visible, while edits still act on the delta.

    Returns:
        One of "accept", "skip", an edit action from SECTION_ACTIONS,
        "view_raw", or BACK.
    """
    view = build_merged_view(
        data, base_path=plan.get("base"), brand_dtc_path=_brand_dtc_path(plan)
    )
    console.print("[dim]Merged view (base defaults applied):[/]")
    show_extracted_data(view)
    return pick_option(
        "Review extracted data",
        [
            ("accept", "Accept and save"),
            ("edit_meta", "Edit vehicle info (meta)"),
            ("edit_items", "Edit maintenance items"),
            ("edit_parts", "Edit parts"),
            ("edit_dtc", "Edit DTC codes"),
            ("view_raw", "View raw AI response"),
            ("skip", "Skip this PDF"),
        ],
    )


def run_pdf_flow(pdf_path: str, provider: dict, api_key: str, client) -> str:
    """Run language → plan → extract → review → save for a single PDF.

    Each step supports back navigation with the left arrow:
      language ← model · extraction ← language · review ← extraction

    Returns:
        "saved", "skipped", or "back" (all the way back to model selection).
    """
    language = None
    while True:
        if language is None:
            detected_lang = PDFReader(pdf_path).detect_language()
            lang = select_language(detected_lang)
            if lang is BACK:
                return "back"
            language = lang

        result = _extract_with_retry(pdf_path, provider, api_key, client, language)
        if result is None:
            language = None
            continue
        data, raw, plan = result

        while True:
            choice = review_pdf(data, raw, plan)
            if choice == "accept":
                console.print("\n[bold]Validating template...[/]")
                is_valid, errors = validate_all(data)
                if not is_valid:
                    print_errors(errors)
                    if confirm2("Save anyway?") is not True:
                        continue
                merged_errors = validate_merged(
                    data,
                    base_path=plan.get("base"),
                    brand_dtc_path=_brand_dtc_path(plan),
                )
                if merged_errors:
                    console.print(
                        f"\n[yellow]! {len(merged_errors)} merged validation warning(s):[/]"
                    )
                    for err in merged_errors:
                        console.print(f"  [dim]- {err}[/]")
                    if confirm2("Save anyway?") is not True:
                        continue
                target = os.path.join(DATA_DIR, plan["target_path"])
                if os.path.exists(target):
                    console.print(
                        f"[yellow]⚠ Target already exists: "
                        f"{plan['target_path']}[/]"
                    )
                    if confirm2("Overwrite?") is not True:
                        continue
                file_path = write_template(plan, data)
                console.print(f"\n[green]✓ Template saved to {os.path.relpath(file_path)}[/]")
                return "saved"
            if choice == "skip":
                console.print("[yellow]Skipped[/]")
                return "skipped"
            if choice is BACK:
                break  # back to extraction (re-run)
            if choice == "view_raw":
                with console.pager():
                    console.print(raw)
                continue
            section = SECTION_ACTIONS.get(choice)
            if section is not None:
                data = edit_section(data, section)

    return "skipped"


def _brand_dtc_path(plan: dict) -> str | None:
    """Brand dtc path for a plan, or None when the template is standalone."""
    if not plan.get("base"):
        return None
    make_slug = plan["target_path"].split("/")[0]
    return f"{make_slug}/dtc.json"


def _extract_with_retry(pdf_path, provider, api_key, client, language):
    """Run AI extraction, retrying on failure.

    Returns:
        (data, raw, plan) on success, or None when the retry loop was aborted
        (the caller re-selects the language).
    """
    while True:
        try:
            return extract_pdf_text_and_ai(pdf_path, provider, api_key, client, language)
        except KeyboardInterrupt:
            console.print("\n[yellow]Extraction aborted[/]")
            return None
        except Exception as exc:
            console.print(f"[red]✗ Extraction failed: {exc}[/]")
            if confirm2("Try again?") is not True:
                return None


STATE_MODE = "mode"
STATE_PATH = "path"
STATE_PROVIDER = "provider"
STATE_MODEL = "model"
STATE_PDF = "pdf"


def _step_mode():
    pick = select_input_mode()
    if pick is BACK:
        return None, None
    return STATE_PATH, pick


def _step_path(input_mode):
    p = select_pdf() if input_mode == "file" else select_folder()
    if p is BACK:
        return STATE_MODE, None, None
    if input_mode == "file":
        pdfs = [p]
    else:
        pdfs = list_pdfs_in_folder(p)
        if not pdfs:
            console.print(f"[red]✗ No PDF files found in {p}[/]")
            return STATE_MODE, None, None
        console.print(f"\n[bold]Found {len(pdfs)} PDF file(s):[/]")
        for i, pdf in enumerate(pdfs, 1):
            console.print(f"  {i}. {os.path.basename(pdf)}")
        if confirm(f"Process all {len(pdfs)} files?") is not True:
            return STATE_MODE, None, None
    return STATE_PROVIDER, pdfs, 0


def _step_provider():
    prov = select_provider()
    if prov is BACK:
        return STATE_PATH, None, None
    return STATE_MODEL, prov, None


def _step_model(provider, api_key, client):
    if api_key is None:
        res = get_api_key(provider)
        if res is BACK:
            return STATE_PROVIDER, None, None
        api_key, _ = res
        client = create_client(provider, api_key)
    if not select_model(provider, api_key):
        return STATE_PROVIDER, api_key, client
    return STATE_PDF, api_key, client


def _step_pdf(pdfs, idx, provider, api_key, client, successful):
    if idx >= len(pdfs):
        console.print(f"\n[bold]Summary:[/] {successful}/{len(pdfs)} templates created")
        return None, idx, successful

    pdf_path = pdfs[idx]
    console.print(f"\n[{STYLE_TITLE}]" + "=" * 60 + "[/]")
    console.print(f"[{STYLE_TITLE}]File {idx + 1}/{len(pdfs)}[/]")
    console.print(f"[{STYLE_TITLE}]" + "=" * 60 + "[/]")
    try:
        status = run_pdf_flow(pdf_path, provider, api_key, client)
    except KeyboardInterrupt:
        console.print("\n[yellow]Interrupted by user[/]")
        return None, idx, successful
    except Exception as exc:
        console.print(f"[red]✗ Error processing {pdf_path}: {exc}[/]")
        status = "skipped"

    if status == "saved":
        successful += 1
        idx += 1
    elif status == "skipped":
        idx += 1
    elif status == "back":
        return STATE_MODEL, idx, successful
    return STATE_PDF, idx, successful


def main():
    print_header("karter template generator", "from workshop manual PDF")

    input_mode = None
    pdfs = []
    idx = 0
    provider = None
    api_key = None
    client = None
    successful = 0
    state = STATE_MODE

    while state is not None:
        if state == STATE_MODE:
            state, input_mode = _step_mode()
        elif state == STATE_PATH:
            state, pdfs, idx = _step_path(input_mode)
        elif state == STATE_PROVIDER:
            state, provider, api_key = _step_provider()
        elif state == STATE_MODEL:
            state, api_key, client = _step_model(provider, api_key, client)
        elif state == STATE_PDF:
            state, idx, successful = _step_pdf(
                pdfs, idx, provider, api_key, client, successful
            )

    console.print("\n[bold green]✓ All done![/]")


if __name__ == "__main__":
    run_cli(main)
