"""UI helpers for interactive CLI tools."""

import os
import sys

from rich.console import Console
from rich.panel import Panel
from rich.progress import (
    BarColumn,
    MofNCompleteColumn,
    Progress,
    SpinnerColumn,
    TextColumn,
    TimeElapsedColumn,
    TimeRemainingColumn,
)
from simple_term_menu import TerminalMenu

console = Console()

# Shared theme
STYLE_TITLE = "bold white"
STYLE_ACCENT = "yellow"
STYLE_OK = "green"
STYLE_ERROR = "red"
STYLE_DIM = "dim"

HEADER = "[bold yellow]▍ karter[/] [dim]template tools[/dim]"


def style(text, style=STYLE_TITLE):
    """Wrap text in a rich style."""
    return f"[{style}]{text}[/]"


def print_title(text):
    """Print a section title in bold white."""
    console.print(f"\n[{STYLE_TITLE}]{text}[/]")


def print_header(title, subtitle=None):
    """Print the welcome header panel with the shared theme."""
    header = f"[bold {STYLE_ACCENT}]▍ {title}[/]"
    if subtitle:
        header += f" [{STYLE_DIM}]{subtitle}[/{STYLE_DIM}]"
    console.print(Panel(header, border_style=STYLE_ACCENT))


def make_progress(show_total=False, show_remaining=False):
    """Build a shared rich Progress bar.

    Args:
        show_total: Show the MofN counter (e.g. ``12/50``).
        show_remaining: Show the remaining time column.
    """
    columns = [SpinnerColumn(), TextColumn("[progress.description]{task.description}")]
    if show_total:
        columns.append(MofNCompleteColumn())
    columns.append(BarColumn())
    columns.append(TextColumn("[progress.percentage]{task.percentage:>3.0f}%"))
    if show_remaining:
        columns.append(TimeRemainingColumn())
    columns.append(TimeElapsedColumn())
    return Progress(*columns, console=console)


def run_cli(main, interrupt_message="Interrupted"):
    """Run a CLI entry point, converting Ctrl+C to a clean exit.

    Args:
        main: Callable to run.
        interrupt_message: Message to print on Ctrl+C.
    """
    try:
        main()
    except KeyboardInterrupt:
        console.print(f"\n[yellow]{interrupt_message}[/]")
        sys.exit(130)


def ask(prompt, default=None, secret=False):
    """Ask for text input with optional default value."""
    suffix = f" [dim]({default})[/dim]" if default is not None else ""
    console.print(f"[bold]{prompt}[/]{suffix}")
    try:
        value = input("> ").strip()
    except EOFError:
        sys.exit()
    if not value and default is not None:
        value = str(default)
    return value


def confirm(prompt, default="y"):
    """Ask for yes/no confirmation."""
    ans = ask(f"{prompt} [dim]Y/n[/dim]", default=default).lower()
    return ans not in ("n", "no")


def pick_option(title, options, default_index=0):
    """Print a menu with arrow key navigation and return the chosen option value (string).

    Args:
        title: Menu title
        options: List of (value, label) tuples
        default_index: Index of default selection (0-based)

    Returns:
        The value of the selected option
    """
    print_title(title)

    labels = [label for value, label in options]
    terminal_menu = TerminalMenu(
        labels,
        menu_cursor="▸ ",
        menu_cursor_style=("fg_yellow",),
        menu_highlight_style=("fg_yellow",),
        cycle_cursor=True,
        clear_menu_on_exit=True,
        cursor_index=default_index,
    )

    choice = terminal_menu.show()

    if choice is None:
        # User pressed Ctrl+C or Esc
        sys.exit()

    return options[choice][0]


def pick_multi(title, options):
    """Menu with arrow keys and multi-select (space to toggle), returns list of values."""
    print_title(title)

    labels = [label for value, label in options]
    terminal_menu = TerminalMenu(
        labels,
        menu_cursor="▸ ",
        menu_cursor_style=("fg_yellow",),
        menu_highlight_style=("fg_yellow",),
        cycle_cursor=True,
        clear_menu_on_exit=True,
        multi_select=True,
        show_multi_select_hint=True,
    )

    choices = terminal_menu.show()

    if choices is None:
        # User pressed Ctrl+C or Esc
        sys.exit()

    if isinstance(choices, int):
        choices = [choices]

    values = []
    for idx in choices:
        if 0 <= idx < len(options):
            values.append(options[idx][0])

    return values


def select_path(kind="file"):
    """Ask for a path (file or folder) with a retry loop.

    Args:
        kind: "file" or "folder".

    Returns:
        A valid path, or None if the user chooses to go back.
    """
    if kind == "folder":
        label, check = "Folder path", os.path.isdir
        not_found = "Folder not found"
        not_type = "Not a folder"
    else:
        label, check = "PDF file path", os.path.isfile
        not_found = "File not found"
        not_type = "Not a file"

    while True:
        value = ask(label)
        if not value:
            console.print(f"[{STYLE_ERROR}]✗ No path provided, try again[/]")
            continue
        if not os.path.exists(value):
            console.print(f"[{STYLE_ERROR}]✗ {not_found}: {value}[/]")
            if confirm("Try again?"):
                continue
            return None
        if not check(value):
            console.print(f"[{STYLE_ERROR}]✗ {not_type}: {value}[/]")
            if confirm("Try again?"):
                continue
            return None
        return value