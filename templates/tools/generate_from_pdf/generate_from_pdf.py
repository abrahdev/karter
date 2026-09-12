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
from pathlib import Path

from rich.console import Console
from rich.panel import Panel
from rich.progress import (
    BarColumn,
    Progress,
    SpinnerColumn,
    TextColumn,
    TimeElapsedColumn,
)
from rich.table import Table

try:
    from openai import OpenAI
except ImportError:
    sys.exit("Missing dependency: run  pip install openai  first")

# Import shared utilities
sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))
from _shared import (
    ask,
    confirm,
    create_client,
    get_api_key,
    pick_option,
    select_model,
    select_provider,
)
from _shared.ui import console

from extractor import clean_extracted_data, extract_with_ai
from pdf_reader import PDFReader
from validator import print_errors, validate_all

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
DATA_DIR = os.path.join(REPO_ROOT, "templates", "data")
HEADER = "[bold yellow]▍ karter template generator[/] [dim]from workshop manual PDF[/dim]"


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
    while True:
        pdf_path = ask("PDF file path")
        if not pdf_path:
            console.print("[red]✗ No PDF path provided, try again[/]")
            continue
        if not os.path.exists(pdf_path):
            console.print(f"[red]✗ File not found: {pdf_path}[/]")
            if confirm("Try again?"):
                continue
            return None
        if not os.path.isfile(pdf_path):
            console.print(f"[red]✗ Not a file: {pdf_path}[/]")
            if confirm("Try again?"):
                continue
            return None
        return pdf_path


def select_folder() -> str | None:
    """Interactive folder selection with retry loop.

    Returns:
        Valid folder path, or None if the user wants to go back
        to the input mode selection.
    """
    while True:
        folder_path = ask("Folder path")
        if not folder_path:
            console.print("[red]✗ No folder path provided, try again[/]")
            continue
        if not os.path.exists(folder_path):
            console.print(f"[red]✗ Folder not found: {folder_path}[/]")
            if confirm("Try again?"):
                continue
            return None
        if not os.path.isdir(folder_path):
            console.print(f"[red]✗ Not a folder: {folder_path}[/]")
            if confirm("Try again?"):
                continue
            return None
        return folder_path


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
    if pick == "other":
        return ask("Language code (e.g., sv, nl)")
    return pick


def show_extracted_data(data: dict) -> None:
    """Display extracted data in a readable format."""
    console.print("\n" + "=" * 60)
    console.print("[bold white]EXTRACTED DATA[/]")
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
        for item in items[:10]:  # Show first 10
            label = item.get("label", item.get("id", "?"))
            interval = []
            if item.get("interval_km"):
                interval.append(f"{item['interval_km']:,} km")
            if item.get("interval_months"):
                interval.append(f"{item['interval_months']} months")
            interval_str = " / ".join(interval) if interval else "no interval"
            console.print(f"  • {label}: {interval_str}")
        if len(items) > 10:
            console.print(f"  [dim]... and {len(items) - 10} more[/]")

    # Parts
    parts = data.get("parts", [])
    if parts:
        console.print(f"\n[bold]Parts ({len(parts)}):[/]")
        for part in parts[:10]:  # Show first 10
            name = part.get("name", part.get("id", "?"))
            qty = part.get("quantity", 1)
            unit = part.get("unit", "unit")
            console.print(f"  • {name}: {qty} {unit}")
        if len(parts) > 10:
            console.print(f"  [dim]... and {len(parts) - 10} more[/]")

    # DTC codes
    dtcs = data.get("obd_dtc_definitions", [])
    if dtcs:
        console.print(f"\n[bold]DTC Codes ({len(dtcs)}):[/]")
        for dtc in dtcs[:5]:  # Show first 5
            code = dtc.get("code", "?")
            desc = dtc.get("description", "")[:50]
            console.print(f"  • {code}: {desc}")
        if len(dtcs) > 5:
            console.print(f"  [dim]... and {len(dtcs) - 5} more[/]")

    console.print("\n" + "=" * 60 + "\n")


def edit_section(data: dict, section: str) -> dict:
    """Interactive editor for a specific section."""
    console.print(f"\n[bold]Editing {section}[/]")
    console.print("[dim]Enter JSON to replace (or press Enter to keep current)[/]")

    current = json.dumps(data.get(section, {} if section == "meta" else []), indent=2)
    console.print(f"\n[yellow]Current value:[/]\n{current}\n")

    new_value = ask("New value (JSON)")
    if new_value:
        try:
            data[section] = json.loads(new_value)
            console.print("[green]✓ Updated[/]")
        except json.JSONDecodeError as e:
            console.print(f"[red]✗ Invalid JSON: {e}[/]")

    return data


def save_template(data: dict) -> str:
    """Save template to templates/data/ directory."""
    make = data.get("meta", {}).get("make", "unknown").lower().replace(" ", "-")
    model = data.get("meta", {}).get("model", "unknown").lower().replace(" ", "-")
    template_id = data.get("id", f"{make}-{model}")

    # Create directory structure
    make_dir = os.path.join(DATA_DIR, make)
    os.makedirs(make_dir, exist_ok=True)

    # Save file
    file_path = os.path.join(make_dir, f"{template_id}.json")
    with open(file_path, "w", encoding="utf-8") as fh:
        json.dump(data, fh, ensure_ascii=False, indent=2)

    return file_path


def regenerate_catalog() -> None:
    """Regenerate index.json and karter-catalog.db."""
    console.print("\n[bold]Regenerating catalog...[/]")

    # Regenerate index.json
    console.print("[dim]  Running generate_index.py...[/]")
    os.system(f"python3 {REPO_ROOT}/templates/tools/generate_index/generate_index.py")

    # Regenerate catalog.db
    console.print("[dim]  Running build_catalog.py...[/]")
    os.system(f"python3 {REPO_ROOT}/templates/tools/build_catalog/build_catalog.py")

    console.print("[green]✓ Catalog regenerated[/]")


def process_single_pdf(
    pdf_path: str,
    provider: dict,
    api_key: str,
    language: str | None = None,
) -> bool:
    """Process a single PDF file.

    Returns:
        True if successful, False if skipped or failed
    """
    console.print(f"\n[bold white]Processing:[/] {os.path.basename(pdf_path)}")

    try:
        reader = PDFReader(pdf_path)
        page_count = reader.get_page_count()
        console.print(f"[dim]✓ PDF loaded: {page_count} pages[/]")
    except Exception as e:
        console.print(f"[red]✗ Failed to load PDF: {e}[/]")
        return False

    # Detect or use provided language
    if language is None:
        detected_lang = reader.detect_language()
        language = select_language(detected_lang)

    # Extract text from PDF
    console.print("\n[bold]Extracting text from PDF...[/]")
    progress = Progress(
        SpinnerColumn(),
        TextColumn("[progress.description]{task.description}"),
        BarColumn(),
        TextColumn("[progress.percentage]{task.percentage:>3.0f}%"),
        TimeElapsedColumn(),
        console=console,
    )
    with progress:
        task = progress.add_task("Reading pages", total=page_count)
        pdf_text = ""
        for i in range(page_count):
            pdf_text += reader.extract_page(i)
            progress.update(task, advance=1)

    console.print(f"[green]✓ Extracted {len(pdf_text):,} characters[/]")

    # AI extraction
    console.print("\n[bold]Analyzing with AI...[/]")
    client = create_client(provider, api_key)

    with progress:
        task = progress.add_task("AI extraction", total=None)
        data = extract_with_ai(client, provider["model"], pdf_text, language)
        progress.update(task, completed=100)

    data = clean_extracted_data(data)
    console.print("[green]✓ Extraction complete[/]")

    # Interactive review
    while True:
        show_extracted_data(data)

        console.print("[bold]Options:[/]")
        console.print("  [1] Accept and save")
        console.print("  [2] Edit vehicle info (meta)")
        console.print("  [3] Edit maintenance items")
        console.print("  [4] Edit parts")
        console.print("  [5] Edit DTC codes")
        console.print("  [6] Skip this PDF")

        choice = ask("Select")

        if choice == "1":
            break
        elif choice == "2":
            data = edit_section(data, "meta")
        elif choice == "3":
            data = edit_section(data, "maintenance_items")
        elif choice == "4":
            data = edit_section(data, "parts")
        elif choice == "5":
            data = edit_section(data, "obd_dtc_definitions")
        elif choice == "6":
            console.print("[yellow]Skipped[/]")
            return False
        else:
            console.print("[red]Invalid choice[/]")

    # Validate
    console.print("\n[bold]Validating template...[/]")
    is_valid, errors = validate_all(data)
    if not is_valid:
        print_errors(errors)
        if not confirm("Save anyway?"):
            return False

    # Save
    file_path = save_template(data)
    console.print(f"\n[green]✓ Template saved to {os.path.relpath(file_path)}[/]")

    return True


def main():
    console.print(Panel(HEADER, border_style="yellow"))

    # Select AI provider (shared for all PDFs)
    provider = select_provider()
    api_key, _ = get_api_key(provider)
    select_model(provider, api_key)

    # Loop for input mode selection with retry
    while True:
        # Step 1: Select input mode
        input_mode = select_input_mode()

        if input_mode == "file":
            # Single file mode
            pdf_path = select_pdf()
            if pdf_path is None:
                continue  # Back to input mode selection
            success = process_single_pdf(pdf_path, provider, api_key)

            if success and confirm("Regenerate index.json and karter-catalog.db?"):
                regenerate_catalog()
            break

        # Batch mode
        folder_path = select_folder()
        if folder_path is None:
            continue  # Back to input mode selection

        pdfs = list_pdfs_in_folder(folder_path)

        if not pdfs:
            console.print(f"[red]✗ No PDF files found in {folder_path}[/]")
            if confirm("Try again?"):
                continue
            break

        console.print(f"\n[bold]Found {len(pdfs)} PDF file(s):[/]")
        for i, pdf in enumerate(pdfs, 1):
            console.print(f"  {i}. {os.path.basename(pdf)}")

        if not confirm(f"Process all {len(pdfs)} files?"):
            break

        # Process each PDF
        successful = 0
        for i, pdf_path in enumerate(pdfs, 1):
            console.print(f"\n[bold white]{'=' * 60}[/]")
            console.print(f"[bold white]File {i}/{len(pdfs)}[/]")
            console.print(f"[bold white]{'=' * 60}[/]")

            try:
                success = process_single_pdf(pdf_path, provider, api_key)
                if success:
                    successful += 1
            except KeyboardInterrupt:
                console.print("\n[yellow]Interrupted by user[/]")
                break
            except Exception as e:
                console.print(f"[red]✗ Error processing {pdf_path}: {e}[/]")

        console.print(f"\n[bold]Summary:[/] {successful}/{len(pdfs)} templates created")

        if successful > 0 and confirm("Regenerate index.json and karter-catalog.db?"):
            regenerate_catalog()
        break

    console.print("\n[bold green]✓ All done![/]")


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        console.print("\n[yellow]Interrupted[/]")
        sys.exit(130)
