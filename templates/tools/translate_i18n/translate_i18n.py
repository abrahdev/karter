#!/usr/bin/env python3
"""Interactive tool to translate templates/i18n/en.json into other languages.

A terminal interface in the style of Claude Code / opencode: inline text
prompts, numbered keyboard selection, clear rich panels and a live progress
bar. It keeps the i18n catalog in sync with a curated provider list:

  * choose between full redo (retranslate everything) or only completing
    missing keys (fills keys that are absent from a language file)
  * validate-only mode (no API call): check key parity/order/divergence
  * pick one or several target languages from templates/i18n
  * select the translation provider from a curated list, or add a custom
    OpenAI-compatible endpoint
  * show an estimated cost before running, then a live progress bar
  * read the API key from templates/tools/.env, an env var, or paste it for
    a single run (optionally saved to .env)
  * resume from checkpoints when a run is interrupted (Ctrl+C safe)

Usage:
  python3 templates/tools/translate_i18n/translate_i18n.py
"""

import json
import os
import random
import sys
import threading
import time
from concurrent.futures import FIRST_COMPLETED, ThreadPoolExecutor, wait

from rich.live import Live
from rich.panel import Panel

# Import shared utilities
sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))
from _shared import (
    BACK,
    ask,
    confirm,
    create_client,
    get_api_key,
    load_prompt,
    make_progress,
    pick_multi,
    pick_option,
    print_header,
    run_cli,
    select_model,
    select_provider,
)
from _shared.ui import console, poll_key, raw_keyboard

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
I18N_DIR = os.path.join(REPO_ROOT, "templates", "i18n")
EN_FILE = os.path.join(I18N_DIR, "en.json")
CKPT_DIR = os.path.join(os.path.dirname(__file__), ".checkpoints")
PROMPTS_FILE = os.path.join(os.path.dirname(__file__), "PROMPTS.md")

DEFAULT_BATCH = 300
MAX_RETRIES = 5
RETRY_BASE = 3
CLIENT_TIMEOUT = 1800.0
DEFAULT_WORKERS = 4

# Hard cap for a silent stream: an attempt fails once this passes with no
# content tokens, so a stuck upstream can never freeze the progress bar.
FIRST_TOKEN_TIMEOUT = 300.0

# How often a language's accumulated result is flushed to its checkpoint
# while batches complete in parallel (avoids dumping ~1-2 MB per batch).
CKPT_EVERY_SECONDS = 5.0

LANG_NAMES = {
    "en": "English",
    "es": "Spanish",
    "et": "Estonian",
    "pt": "Portuguese (BR)",
    "de": "German",
    "ru": "Russian",
    "fr": "French",
    "pl": "Polish",
    "it": "Italian",
    "nl": "Dutch",
}

# Rough tokens per key used only for the cost estimate.
TOKENS_PER_KEY = 18


def abort(value):
    """Exit with a message when the user navigates back (left arrow)."""
    if value is BACK:
        sys.exit("Aborted")
    return value


def load_en():
    with open(EN_FILE, encoding="utf-8") as fh:
        return json.load(fh)


def available_languages():
    langs = {}
    for fname in sorted(os.listdir(I18N_DIR)):
        if fname.startswith("app_") or not fname.endswith(".json"):
            continue
        code = fname[:-5]
        if code == "en":
            continue
        langs[code] = fname
    return langs


# ---------- languages / mode ----------

def select_languages(langs):
    codes = list(langs)
    options = [(c, f"{c}  {LANG_NAMES.get(c, c)}") for c in codes]
    options.append(("new", "New language code"))
    picked = abort(pick_multi("Select target language(s)", options))
    if not picked:
        sys.exit("No language selected")
    if "new" in picked:
        code = abort(ask("New language code (e.g. sv)"))
        picked = [c for c in picked if c != "new"] + [code]
    return picked


def select_mode():
    return abort(
        pick_option(
            "Choose a mode",
            [
                ("full", "Full redo — retranslate everything"),
                ("missing", "Complete missing keys only (keep existing)"),
                ("validate", "Validate only — no API call"),
            ],
            default_index=2,
        )
    )


# ---------- prompt / translation ----------

def build_prompt(lang_code):
    lang_name = LANG_NAMES.get(lang_code, lang_code)
    return load_prompt(PROMPTS_FILE, lang_name=lang_name)


def translate_batch(client, system, items, model, on_live=None):
    payload = {k: v for k, v in items}
    last_error = None
    for attempt in range(MAX_RETRIES):
        try:
            chunks = []
            chars = 0
            started = time.monotonic()
            if on_live:
                on_live(0.0, 0)
            stream = client.chat.completions.create(
                model=model,
                temperature=0.1,
                response_format={"type": "json_object"},
                stream=True,
                messages=[
                    {"role": "system", "content": system},
                    {"role": "user", "content": json.dumps(payload, ensure_ascii=False)},
                ],
            )
            for chunk in stream:
                if not chunk.choices:
                    continue
                delta = chunk.choices[0].delta
                if delta and delta.content:
                    chunks.append(delta.content)
                    chars += len(delta.content)
                elapsed = time.monotonic() - started
                if not chunks and elapsed > FIRST_TOKEN_TIMEOUT:
                    raise TimeoutError(
                        f"no content received from the model in {elapsed:.0f}s"
                    )
                if on_live:
                    on_live(elapsed, chars)
            out = json.loads("".join(chunks))
            if not isinstance(out, dict):
                raise ValueError(f"response is not a JSON object: {type(out).__name__}")
            missing = sorted(set(payload) - set(out))
            extra = sorted(set(out) - set(payload))
            if missing or extra:
                raise ValueError(
                    f"response keys mismatch: missing={missing} extra={extra}"
                )
            empty = sorted(
                k for k, v in out.items()
                if not isinstance(v, str) or not v.strip()
            )
            if empty:
                raise ValueError(f"empty or non-string translations: {empty}")
            return out
        except Exception as exc:
            last_error = exc
            if attempt < MAX_RETRIES - 1:
                wait = RETRY_BASE * (2 ** attempt) + random.uniform(0, 2)
                console.print(f"[yellow]  retry {attempt + 1}/{MAX_RETRIES} in {wait:.0f}s[/] ({type(exc).__name__})")
                time.sleep(wait)
    raise RuntimeError(f"batch failed after {MAX_RETRIES} retries: {last_error}")


# ---------- checkpoints ----------

def checkpoint_path(lang):
    os.makedirs(CKPT_DIR, exist_ok=True)
    return os.path.join(CKPT_DIR, f"{lang}.json")


def save_checkpoint(lang, data):
    with open(checkpoint_path(lang), "w", encoding="utf-8") as fh:
        json.dump(data, fh, ensure_ascii=False)


def load_checkpoint(lang):
    path = checkpoint_path(lang)
    if os.path.exists(path):
        with open(path, encoding="utf-8") as fh:
            return json.load(fh)
    return {}


def clear_checkpoint(lang):
    path = checkpoint_path(lang)
    if os.path.exists(path):
        os.remove(path)


def write_json(path, data, keys_order):
    ordered = {k: data[k] for k in keys_order}
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(json.dumps(ordered, ensure_ascii=False, indent=2) + "\n")


# ---------- validate ----------

def validate(lang):
    dest = os.path.join(I18N_DIR, f"{lang}.json")
    if not os.path.exists(dest):
        console.print(f"[red]✗ {lang}.json does not exist[/]")
        return
    en = load_en()
    with open(dest, encoding="utf-8") as fh:
        tr = json.load(fh)
    en_keys = list(en.keys())
    tr_keys = list(tr.keys())
    if en_keys != tr_keys:
        missing = [k for k in en_keys if k not in tr]
        extra = [k for k in tr_keys if k not in en]
        console.print(
            f"[yellow]! {lang}: key mismatch[/] missing={len(missing)} extra={len(extra)}"
        )
    same = sum(1 for k in en_keys if en[k] == tr.get(k))
    div = len(en_keys) - same
    status = "[green]✓ OK[/]" if en_keys == tr_keys else "[yellow]! drift[/]"
    console.print(f"{status} [bold]{lang}[/]  {len(tr_keys)} keys  ·  {div} translated  ·  {same} identical to EN")


# ---------- estimate ----------

def estimate(provider, total_keys):
    tok_in = total_keys * TOKENS_PER_KEY
    tok_out = total_keys * TOKENS_PER_KEY * 0.6
    cost = (tok_in / 1_000_000) * provider["price_in"] + (tok_out / 1_000_000) * provider["price_out"]
    return tok_in, tok_out, cost


# ---------- result loading ----------

def load_result(lang, mode):
    """Load existing translations (missing mode) merged with the checkpoint."""
    dest = os.path.join(I18N_DIR, f"{lang}.json")
    if mode == "missing" and os.path.exists(dest):
        with open(dest, encoding="utf-8") as fh:
            result = json.load(fh)
    else:
        result = {}
    ckpt = load_checkpoint(lang)
    if ckpt:
        result = dict(result)
        result.update(ckpt)
        console.print(f"[cyan]↻ Resuming[/] {lang} from checkpoint ({len(ckpt)} keys)")
    return result


# ---------- translate (parallel) ----------

class _Dashboard:
    """Live renderable: the language progress bars, a global timer and one
    timer per worker thread.

    ``Progress`` is embedded via its ``__rich__`` hook; the global and per-slot
    timers read ``time.monotonic()`` at render time, so the ``Live``'s own
    auto-refresh thread ticks them without any explicit update calls.
    """

    def __init__(self, progress, worker_count):
        self.progress = progress
        self.global_start = time.monotonic()
        self.workers = [None] * worker_count

    def claim_slot(self, lang, batch, total):
        for i, slot in enumerate(self.workers):
            if slot is None:
                self.workers[i] = {
                    "lang": lang,
                    "batch": batch,
                    "total": total,
                    "start": time.monotonic(),
                }
                return i
        return 0

    def release_slot(self, slot):
        if slot is not None and 0 <= slot < len(self.workers):
            self.workers[slot] = None

    def __rich_console__(self, console, options):
        yield self.progress
        yield ""
        yield f"[bold]Global:[/] {time.monotonic() - self.global_start:.0f}s"
        for i, slot in enumerate(self.workers):
            if slot is None:
                yield f"  worker {i + 1}: idle"
            else:
                yield (
                    f"  [cyan]worker {i + 1}[/] · {slot['lang']} batch "
                    f"{slot['batch']}/{slot['total']} · "
                    f"{time.monotonic() - slot['start']:.0f}s"
                )
        yield ""
        yield "[dim]Press q to stop after the in-flight batches finish.[/dim]"


def _task_worker(
    task, state, client, provider, progress, glock, abort_event, dashboard=None
):
    """Run a single (lang, batch) translation task.

    Appends the translated keys to the language result and checkpoints them
    (throttled) under the language lock. Claims a dashboard worker slot so the
    live view shows a per-thread timer. Returns ``None`` when the batch failed
    after all retries (signals abort), else ``(lang, batch_n)``.
    """
    lang, batch_n, total_batches, chunk = task
    st = state[lang]

    if abort_event.is_set():
        return None

    slot = None
    if dashboard is not None:
        with glock:
            slot = dashboard.claim_slot(lang, batch_n, total_batches)

    try:
        try:
            translated = translate_batch(
                client, st["system"], chunk, provider["model"]
            )
        except Exception as exc:
            console.print(
                f"[red]  {lang} batch {batch_n}/{total_batches} failed: {exc}[/]"
            )
            abort_event.set()
            return None

        with st["lock"]:
            st["result"].update(translated)
            st["completed"] += 1
            now = time.monotonic()
            if (
                now - st["last_ckpt"] >= CKPT_EVERY_SECONDS
                or st["completed"] == st["batches"]
            ):
                save_checkpoint(lang, st["result"])
                st["last_ckpt"] = now
        with glock:
            progress.update(st["task"], advance=len(chunk))
        return lang, batch_n
    finally:
        if dashboard is not None:
            with glock:
                dashboard.release_slot(slot)


def _finalize(lang, st):
    """Write the final language file and clear its checkpoint."""
    en_keys = st["en_keys"]
    missing = [k for k in en_keys if k not in st["result"]]
    if missing:
        raise RuntimeError(f"{lang}: {len(missing)} keys still missing: {missing[:10]}")
    write_json(st["dest"], st["result"], en_keys)
    clear_checkpoint(lang)
    console.print(
        f"[green]✓ {lang}: saved[/] {len(st['result'])} keys → "
        f"{os.path.relpath(st['dest'])} in {time.monotonic() - st['start']:.0f}s"
    )


def _key_listener(stop_event, fd):
    """Set ``stop_event`` when the user presses ``q`` (graceful stop).

    Runs in a daemon thread while ``raw_keyboard()`` keeps stdin in cbreak
    mode. Ignores every other key.
    """
    while not stop_event.is_set():
        ch = poll_key(fd, 0.2)
        if ch in ("q", "Q"):
            stop_event.set()
            return


def _wait_all(futures, stop_event):
    """Poll the futures, breaking early on failure or a requested stop.

    Returns:
        True when a batch failed after all retries (abort).
    """
    aborted = False
    pending = set(futures)
    while pending:
        done, pending = wait(pending, timeout=0.2, return_when=FIRST_COMPLETED)
        for fut in done:
            if fut.result() is None:
                aborted = True
        if aborted or stop_event.is_set():
            break
    return aborted


def _run_parallel(
    targets,
    mode,
    client,
    provider,
    batch_size,
    workers,
    progress,
    dashboard=None,
    stop_event=None,
    interactive=False,
):
    """Translate all target languages in parallel batches.

    A single global thread pool runs every (lang, batch) task, so both
    languages and batches run concurrently. Each language keeps its own
    result and checkpoint behind a per-language lock; the rich progress bar
    is guarded by a global lock.

    Exit paths:
    * a batch fails after all retries -> abort: queued tasks are cancelled,
      in-flight batches are drained (and still checkpointed), exit code 1.
    * the user presses ``q`` (interactive) or sets ``stop_event`` -> graceful
      stop: queued tasks are cancelled, in-flight batches are drained,
      languages that completed fully are finalized, the rest stay in their
      checkpoints for resume, exit code 0.

    ``workers=1`` behaves exactly like the old sequential loop.
    Returns ``"done"``, ``"stopped"`` or ``None`` (nothing to translate).
    """
    en = load_en()
    en_keys = list(en.keys())
    state = {}
    tasks = []
    for lang in targets:
        result = load_result(lang, mode)
        todo = [(k, en[k]) for k in en_keys if k not in result]
        if not todo:
            console.print(f"[green]✓ {lang}:[/] nothing to translate, already complete")
            validate(lang)
            continue
        console.print(f"[bold]{lang}:[/] {len(todo)} keys to translate (batch={batch_size})")
        system = build_prompt(lang)
        task = progress.add_task(f"[bold]{lang}[/]", total=len(todo))
        chunks = [todo[i:i + batch_size] for i in range(0, len(todo), batch_size)]
        state[lang] = {
            "lang": lang,
            "result": result,
            "en_keys": en_keys,
            "dest": os.path.join(I18N_DIR, f"{lang}.json"),
            "system": system,
            "batches": len(chunks),
            "task": task,
            "lock": threading.Lock(),
            "completed": 0,
            "last_ckpt": 0.0,
            "start": time.monotonic(),
        }
        for n, chunk in enumerate(chunks, 1):
            tasks.append((lang, n, len(chunks), chunk))

    if not tasks:
        return "done"

    if stop_event is None:
        stop_event = threading.Event()

    glock = threading.Lock()
    abort_event = threading.Event()
    executor = ThreadPoolExecutor(max_workers=workers)
    futures = [
        executor.submit(
            _task_worker,
            t,
            state,
            client,
            provider,
            progress,
            glock,
            abort_event,
            dashboard,
        )
        for t in tasks
    ]
    aborted = False
    try:
        if interactive and sys.stdin.isatty():
            with raw_keyboard() as fd:
                listener = threading.Thread(
                    target=_key_listener, args=(stop_event, fd), daemon=True
                )
                listener.start()
                try:
                    aborted = _wait_all(futures, stop_event)
                finally:
                    stop_event.set()
                    listener.join(timeout=1.0)
        else:
            aborted = _wait_all(futures, stop_event)
    except KeyboardInterrupt:
        aborted = True
        raise
    finally:
        for fut in futures:
            fut.cancel()
        executor.shutdown(wait=True)
        for st in state.values():
            with st["lock"]:
                if st["completed"]:
                    save_checkpoint(st["lang"], st["result"])

    if aborted:
        console.print(
            "\n[yellow]Aborted: a batch failed. "
            "Checkpoints saved — re-run to resume.[/]"
        )
        sys.exit(1)

    for lang, st in state.items():
        with st["lock"]:
            if st["completed"] == st["batches"]:
                _finalize(lang, st)
            elif not stop_event.is_set():
                raise RuntimeError(
                    f"{lang}: run ended with {st['completed']}/{st['batches']} "
                    "batches completed"
                )
        progress.remove_task(st["task"])

    incomplete = [
        lang for lang, st in state.items() if st["completed"] < st["batches"]
    ]
    if incomplete and stop_event.is_set():
        console.print(
            "\n[yellow]Stopped by user. "
            "Checkpoints saved — re-run to resume.[/]"
        )
        return "stopped"
    return "done"


# ---------- main ----------

def main():
    print_header("karter i18n", "translate & maintain catalog")

    provider = abort(select_provider())
    res = abort(get_api_key(provider))
    api_key, _ = res
    if not select_model(provider, api_key):
        sys.exit("Aborted")
    langs = available_languages()
    targets = select_languages(langs)
    mode = select_mode()

    if mode == "validate":
        console.print()
        for lang in targets:
            validate(lang)
        return

    client = create_client(provider, api_key, timeout=CLIENT_TIMEOUT)

    batch_size = abort(ask("Batch size", str(DEFAULT_BATCH)))
    try:
        batch_size = int(batch_size)
    except ValueError:
        batch_size = DEFAULT_BATCH
    if batch_size < 1:
        batch_size = DEFAULT_BATCH

    workers = abort(ask("Parallel requests", str(DEFAULT_WORKERS)))
    try:
        workers = int(workers)
    except ValueError:
        workers = DEFAULT_WORKERS
    workers = max(1, min(workers, 16))

    en = load_en()
    pending = 0
    for lang in targets:
        result = load_result(lang, mode)
        pending += sum(1 for k in en if k not in result)
    total_keys = pending
    tok_in, tok_out, cost = estimate(provider, total_keys)
    console.print(
        Panel(
            f"[bold]Provider:[/] {provider['name']}\n"
            f"[bold]Model:[/] {provider['model']}\n"
            f"[bold]Languages:[/] {', '.join(targets)}\n"
            f"[bold]Keys to translate:[/] {total_keys:,} (of {len(en):,} total per language)\n"
            f"[bold]Estimated tokens:[/] ~{tok_in:,.0f} in / ~{tok_out:,.0f} out\n"
            f"[bold]Estimated cost:[/] [green]${cost:.3f}[/] (approx.)\n"
            f"[bold]Parallel requests:[/] {workers}",
            title="Configuration",
            border_style="yellow",
        )
    )

    if confirm("Proceed") is not True:
        sys.exit("Aborted by user")

    progress = make_progress(show_total=True, show_remaining=True)
    dashboard = _Dashboard(progress, workers)
    with Live(dashboard, console=console, refresh_per_second=8):
        status = _run_parallel(
            targets,
            mode,
            client,
            provider,
            batch_size,
            workers,
            progress,
            dashboard,
            interactive=True,
        )

    if status == "stopped":
        console.print("[bold yellow]✓ Stopped cleanly. Re-run to finish the rest.[/]")
    else:
        console.print("\n[bold green]✓ All done.[/]")


if __name__ == "__main__":
    run_cli(main, interrupt_message="Interrupted. Checkpoints are saved — re-run to resume.")