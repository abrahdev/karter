"""UI helpers for interactive CLI tools."""

import sys

from rich.console import Console
from simple_term_menu import TerminalMenu

console = Console()

HEADER = "[bold yellow]▍ karter[/] [dim]template tools[/dim]"


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
    # Print title in bold white
    console.print(f"\n[bold white]{title}[/]")
    
    # Extract labels for the menu
    labels = [label for value, label in options]
    
    # Create terminal menu with arrow key navigation
    terminal_menu = TerminalMenu(
        labels,
        menu_cursor="▸ ",
        menu_cursor_style=("fg_yellow",),
        menu_highlight_style=("fg_yellow",),
        cycle_cursor=True,
        clear_menu_on_exit=True,
        cursor_index=default_index,
    )
    
    # Show menu and get selection
    choice = terminal_menu.show()
    
    if choice is None:
        # User pressed Ctrl+C or Esc
        sys.exit()
    
    return options[choice][0]


def pick_multi(title, options):
    """Menu with arrow keys and multi-select (space to toggle), returns list of values."""
    # Print title in bold white
    console.print(f"\n[bold white]{title}[/]")
    
    # Extract labels for the menu
    labels = [label for value, label in options]
    
    # Create terminal menu with multi-select
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
    
    # Show menu and get selections
    choices = terminal_menu.show()
    
    if choices is None:
        # User pressed Ctrl+C or Esc
        sys.exit()
    
    # Handle single "all" selection or multiple selections
    if isinstance(choices, int):
        choices = [choices]
    
    values = []
    for idx in choices:
        if 0 <= idx < len(options):
            values.append(options[idx][0])
    
    return values
