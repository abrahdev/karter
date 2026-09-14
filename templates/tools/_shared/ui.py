"""UI helpers for interactive CLI tools."""

import os
import select as _select
import sys
import termios
import tty

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

console = Console()

# Shared theme
STYLE_TITLE = "bold white"
STYLE_ACCENT = "yellow"
STYLE_OK = "green"
STYLE_ERROR = "red"
STYLE_DIM = "dim"

HEADER = "[bold yellow]▍ karter[/] [dim]template tools[/dim]"

# Sentinel returned by the interactive helpers when the user navigates back
# with the left arrow key (or Esc inside a text input).
BACK = object()


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


# ---------- raw keyboard ----------

def _read_byte(fd, timeout):
    """Read one byte from a raw-mode fd, or None on timeout."""
    if _select.select([fd], [], [], timeout)[0]:
        raw = os.read(fd, 1)
        return raw.decode("utf-8", "replace") if raw else None
    return None


# Byte pushed back by read_key so the *next* read_key call handles it (e.g. an
# Enter that arrives right after a paste burst).
_pending = ""


def _push_back(ch):
    global _pending
    _pending = ch + _pending


def _next_byte(fd, timeout):
    """Read the next byte: from the pending buffer first, then from fd."""
    global _pending
    if _pending:
        byte, _pending = _pending[0], _pending[1:]
        return byte
    return _read_byte(fd, timeout)


# Max characters drained in a single non-bracketed paste burst.
BURST_MAX = 2000
# Seconds to keep draining a burst while bytes keep arriving.
BURST_WINDOW = 0.02


def _read_paste(fd):
    """Accumulate a bracketed-paste payload (after ``ESC[200~``)."""
    buf = ""
    end = "\x1b[201~"
    while True:
        piece = _read_byte(fd, 0.5)
        if piece is None:
            break
        buf += piece
        if buf.endswith(end):
            return buf[: -len(end)]
    return buf


def read_key():
    """Read a single key press from the terminal.

    Returns:
        One of ``"up"``, ``"down"``, ``"left"``, ``"right"``, ``"enter"``,
        ``"esc"``, ``"backspace"``, a printable character, or the full text
        of a paste (bracketed or a plain burst). Ctrl+C / Ctrl+D raise
        KeyboardInterrupt.
    """
    fd = sys.stdin.fileno()
    old = termios.tcgetattr(fd)
    try:
        # Enter cbreak once for the whole key press: re-entering it with
        # tty.setcbreak() between reads would flush the remaining escape
        # bytes (tty.setcbreak uses TCSAFLUSH), breaking arrow-key parsing.
        tty.setcbreak(fd)
        ch = _next_byte(fd, None)
        if not ch:
            raise KeyboardInterrupt
        if ch in ("\x03", "\x04"):
            raise KeyboardInterrupt
        if ch == "\x1b":
            rest = _read_byte(fd, 0.1) or ""
            if rest == "[":
                seq = _read_byte(fd, 0.1) or ""
                if seq == "2":
                    nxt = _read_byte(fd, 0.1) or ""
                    if nxt == "0":
                        nxt2 = _read_byte(fd, 0.1) or ""
                        if nxt2 == "0" and (_read_byte(fd, 0.1) or "") == "~":
                            return _read_paste(fd)
                return {"A": "up", "B": "down", "C": "right", "D": "left"}.get(seq, "esc")
            if rest in ("", "\x1b"):
                return "esc"
            return rest
        if ch in ("\r", "\n"):
            return "enter"
        if ch == "\x7f":
            return "backspace"
        # Printable char: drain the rest of a paste burst (terminals without
        # bracketed paste send all characters at once). A control char that
        # follows the burst is pushed back for the next read_key call.
        buf = ch
        while len(buf) < BURST_MAX:
            nxt = _read_byte(fd, BURST_WINDOW)
            if nxt is None:
                break
            if nxt in ("\x03", "\x04"):
                raise KeyboardInterrupt
            if nxt in ("\r", "\n", "\x7f", "\x1b"):
                _push_back(nxt)
                break
            buf += nxt
        return buf
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old)


# ---------- menus ----------

def _render_menu(title, options, index, hint, selected=None):
    """Render a menu block. ``index`` is the highlighted option within
    ``options`` (which may already be a paged window)."""
    width = max(40, console.width)
    lines = [f"[bold]{title}[/]"]
    for i, (value, label) in enumerate(options):
        label = label if len(label) <= width - 6 else label[: width - 7] + "…"
        marker = "▸ " if i == index else "  "
        mark = "[green]✓[/] " if selected is not None and i in selected else ""
        row_style = "bold yellow" if i == index else "white"
        lines.append(f"[{row_style}]{mark}{marker}{label}[/]")
    lines.append(f"[dim]{hint}[/dim]")
    return "\n".join(lines)


def _redraw_menu(block, lines):
    """Overwrite the previous menu block (``lines`` tall) in place."""
    sys.stdout.write(f"\x1b[{lines}A")
    for _ in range(lines):
        sys.stdout.write("\x1b[2K\x1b[1B")
    sys.stdout.write(f"\x1b[{lines}A")
    console.print(block)


def _scroll_options(n, index, page_size):
    top = max(0, index - page_size // 2)
    if top + page_size > n:
        top = max(0, n - page_size)
    return top


def select(title, options, default=0, back=True):
    """Arrow-key single-select menu.

    Args:
        title: Menu title.
        options: List of (value, label) tuples.
        default: Index of the initially highlighted option.
        back: Whether the left arrow navigates back (returns BACK).

    Returns:
        The selected option value, or BACK if the user pressed ←.
        Esc / Ctrl+C raise KeyboardInterrupt.
    """
    if not options:
        raise ValueError("select() requires at least one option")
    n = len(options)
    page_size = max(5, console.height - 5)
    if page_size > n:
        page_size = n
    index = max(0, min(default, n - 1))
    top = _scroll_options(n, index, page_size)

    hint = "  ↑/↓ move · Enter select · ← back · Esc exit"
    if not back:
        hint = "  ↑/↓ move · Enter select · Esc exit"

    first = True
    while True:
        marks = ""
        if top > 0:
            marks += " ↑"
        if top + page_size < n:
            marks += " ↓"
        win = options[top:top + page_size]
        block = _render_menu(title, win, index - top, hint + marks)
        if first:
            console.print("\n" + block)
            first = False
        else:
            _redraw_menu(block, page_size + 2)
        key = read_key()
        if key == "up":
            if index > 0:
                index -= 1
                if index < top:
                    top = index
        elif key == "down":
            if index < n - 1:
                index += 1
                if index >= top + page_size:
                    top = index - page_size + 1
        elif key == "enter":
            console.print()
            return options[index][0]
        elif key == "left" and back:
            console.print()
            return BACK
        elif key == "esc":
            raise KeyboardInterrupt


def pick_option(title, options, default_index=0):
    """Backwards-compatible single-select menu (see ``select``)."""
    return select(title, options, default=default_index)


def pick_multi(title, options):
    """Arrow-key multi-select menu (Space toggles, Enter confirms).

    Returns:
        List of selected option values, or BACK if the user pressed ←.
        Esc / Ctrl+C raise KeyboardInterrupt.
    """
    n = len(options)
    if not n:
        return []
    index = 0
    selected = set()
    hint = "  ↑/↓ move · Space toggle · Enter confirm · ← back · Esc exit"
    first = True
    while True:
        win = options
        win_index = index
        block = _render_menu(title, win, win_index, hint, selected=selected)
        if first:
            console.print("\n" + block)
            first = False
        else:
            _redraw_menu(block, n + 2)
        key = read_key()
        if key == "up":
            index = (index - 1) % n
        elif key == "down":
            index = (index + 1) % n
        elif key == "left":
            console.print()
            return BACK
        elif key == " ":
            if index in selected:
                selected.discard(index)
            else:
                selected.add(index)
        elif key == "enter":
            console.print()
            if not selected:
                return BACK
            return [options[i][0] for i in sorted(selected)]
        elif key == "esc":
            raise KeyboardInterrupt


# ---------- text input ----------

def ask_line(prompt, default=None):
    """Single-line text input with contextual back navigation.

    The left arrow moves the cursor within the text; once the cursor is at
    the start of the input it returns BACK. Esc also returns BACK.

    Args:
        prompt: Prompt text.
        default: Optional default value returned on Enter with no input.

    Returns:
        The entered string, or BACK if the user cancelled.
    """
    value, cursor = "", 0
    base = str(default) if default is not None else None
    suffix = f" [dim]({default})[/dim]" if default is not None else ""
    console.print(f"\n[bold]{prompt}[/]{suffix}")
    first = True
    while True:
        display = value if value or base is None else base
        rendered = display[:cursor] + "▎" + display[cursor:]
        if not first:
            sys.stdout.write("\x1b[1A\x1b[2K\r")
        console.print(f"> {rendered}")
        first = False
        key = read_key()
        if key == "enter":
            console.print()
            return value or base or ""
        if key == "left":
            if cursor > 0:
                cursor -= 1
            else:
                console.print()
                return BACK
        elif key == "right":
            if cursor < len(value):
                cursor += 1
        elif key == "backspace":
            if cursor > 0:
                value = value[:cursor - 1] + value[cursor:]
                cursor -= 1
        elif key == "esc":
            console.print()
            return BACK
        elif len(key) == 1:
            value = value[:cursor] + key + value[cursor:]
            cursor += 1
        elif len(key) > 1:
            value = value[:cursor] + key + value[cursor:]
            cursor += len(key)


def confirm2(prompt, default="y"):
    """Yes/no confirmation using the y/n keys.

    Returns:
        True or False for the chosen answer, or BACK if ← was pressed.
        Esc / Ctrl+C raise KeyboardInterrupt.
    """
    if default not in ("y", "n"):
        default = "y"
    label = "Y/n" if default == "y" else "y/N"
    console.print(f"\n[bold]{prompt}[/] [dim]({label})[/dim]")
    while True:
        key = read_key()
        if key == "enter":
            console.print()
            return default == "y"
        if key in ("y", "Y"):
            console.print()
            return True
        if key in ("n", "N"):
            console.print()
            return False
        if key == "left":
            console.print()
            return BACK
        if key == "esc":
            raise KeyboardInterrupt


def ask(prompt, default=None):
    """Backwards-compatible text input (see ``ask_line``)."""
    return ask_line(prompt, default)


def confirm(prompt, default="y"):
    """Backwards-compatible confirmation (see ``confirm2``)."""
    return confirm2(prompt, default)


def select_path(kind="file"):
    """Ask for a path (file or folder) with a retry loop.

    Args:
        kind: "file" or "folder".

    Returns:
        A valid path, or BACK if the user wants to go back.
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
        if value is BACK:
            return BACK
        if not value:
            console.print(f"[{STYLE_ERROR}]✗ No path provided, try again[/]")
            continue
        if not os.path.exists(value):
            console.print(f"[{STYLE_ERROR}]✗ {not_found}: {value}[/]")
            if confirm("Try again?") is not True:
                return BACK
            continue
        if not check(value):
            console.print(f"[{STYLE_ERROR}]✗ {not_type}: {value}[/]")
            if confirm("Try again?") is not True:
                return BACK
            continue
        return value