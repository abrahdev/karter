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
import sys
import time

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
from rich.table import Table

try:
    from openai import OpenAI
except ImportError:
    sys.exit("Missing dependency: run  pip install openai  first")

console = Console()

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
I18N_DIR = os.path.join(REPO_ROOT, "templates", "i18n")
EN_FILE = os.path.join(I18N_DIR, "en.json")
ENV_FILE = os.path.join(os.path.dirname(__file__), ".env")
CKPT_DIR = os.path.join(os.path.dirname(__file__), ".checkpoints")

DEFAULT_BATCH = 600
MAX_RETRIES = 5
RETRY_BASE = 3

MODELS_CACHE = os.path.join(os.path.expanduser("~"), ".cache", "opencode", "models.json")

# Curated provider list. Each entry: base_url, model, env var, and per-1M
# token prices (input/output, USD) used for the cost estimate. Prices are
# approximations; edit freely. cache_key maps to the provider id used in the
# local models.json cache (when available) for dynamic prices.
PROVIDERS = [
    {
        "name": "OpenCode Go (deepseek-v4-flash)",
        "base_url": "https://opencode.ai/zen/go/v1",
        "model": "deepseek-v4-flash",
        "env_var": "OPENCODE_API_KEY",
        "cache_key": "opencode-go",
        "price_in": 0.2,
        "price_out": 0.5,
    },
    {
        "name": "DeepSeek (deepseek-chat)",
        "base_url": "https://api.deepseek.com",
        "model": "deepseek-chat",
        "env_var": "DEEPSEEK_API_KEY",
        "cache_key": "deepseek",
        "price_in": 0.27,
        "price_out": 1.10,
    },
    {
        "name": "OpenAI (gpt-4o-mini)",
        "base_url": "https://api.openai.com/v1",
        "model": "gpt-4o-mini",
        "env_var": "OPENAI_API_KEY",
        "cache_key": "openai",
        "price_in": 0.15,
        "price_out": 0.60,
    },
    {
        "name": "Anthropic (claude-haiku)",
        "base_url": "https://api.anthropic.com/v1",
        "model": "claude-haiku-4-5-20251001",
        "env_var": "ANTHROPIC_API_KEY",
        "cache_key": "anthropic",
        "price_in": 1.0,
        "price_out": 5.0,
    },
    {
        "name": "Groq (llama-3.3-70b)",
        "base_url": "https://api.groq.com/openai/v1",
        "model": "llama-3.3-70b-versatile",
        "env_var": "GROQ_API_KEY",
        "cache_key": "groq",
        "price_in": 0.59,
        "price_out": 0.79,
    },
    {
        "name": "Mistral (mistral-small)",
        "base_url": "https://api.mistral.ai/v1",
        "model": "mistral-small-latest",
        "env_var": "MISTRAL_API_KEY",
        "cache_key": "mistral",
        "price_in": 0.1,
        "price_out": 0.3,
    },
    {
        "name": "OpenRouter (auto)",
        "base_url": "https://openrouter.ai/api/v1",
        "model": "openrouter/auto",
        "env_var": "OPENROUTER_API_KEY",
        "cache_key": "openrouter",
        "price_in": 0.15,
        "price_out": 0.60,
    },
]

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

HEADER = "[bold cyan]▍ karter i18n[/] [dim]translate & maintain catalog[/dim]"


# ---------- tiny readline-based prompt (agent-style) ----------

def ask(prompt, default=None, secret=False):
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
    ans = ask(f"{prompt} [dim]Y/n[/dim]", default=default).lower()
    return ans not in ("n", "no")


# ---------- env ----------

def load_env():
    if not os.path.exists(ENV_FILE):
        return {}
    env = {}
    with open(ENV_FILE, encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            key, _, value = line.partition("=")
            env[key.strip()] = value.strip().strip('"').strip("'")
    return env


def save_env(env):
    lines = [f"{k}={v}" for k, v in env.items()]
    with open(ENV_FILE, "w", encoding="utf-8") as fh:
        fh.write("\n".join(lines) + "\n")


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


# ---------- numbered menu helpers ----------

def pick_option(title, options, default_index=0):
    """Print a numbered menu and return the chosen option value (string)."""
    console.print(f"\n[bold]{title}[/]")
    table = Table(show_header=False, box=None, pad_edge=False)
    table.add_column(justify="right", style="cyan", width=3)
    table.add_column(style="white")
    for i, (value, label) in enumerate(options, 1):
        marker = "▸" if i == default_index else " "
        table.add_row(f" {i}", f"{marker} {label}")
    console.print(table)
    choice = ask("Select [dim]number[/dim]")
    if not choice:
        return options[default_index - 1][0]
    try:
        idx = int(choice)
        if 1 <= idx <= len(options):
            return options[idx - 1][0]
    except ValueError:
        pass
    console.print("[red]Invalid selection.[/]")
    sys.exit()


def pick_multi(title, options):
    """Numbered menu with comma/ranges, returns list of values."""
    console.print(f"\n[bold]{title}[/]")
    table = Table(show_header=False, box=None, pad_edge=False)
    table.add_column(justify="right", style="cyan", width=3)
    table.add_column(style="white")
    for i, (value, label) in enumerate(options, 1):
        table.add_row(f" {i}", f" {label}")
    console.print(table)
    raw = ask("Select numbers [dim]comma or range, e.g. 1,3,5-7 or all[/dim]")
    if raw in ("", "all"):
        return [v for v, _ in options]
    selected = []
    for part in raw.split(","):
        part = part.strip()
        if not part:
            continue
        if "-" in part:
            a, b = part.split("-", 1)
            selected.extend(range(int(a), int(b) + 1))
        else:
            selected.append(int(part))
    values = []
    for idx in selected:
        if 1 <= idx <= len(options):
            values.append(options[idx - 1][0])
    return values


# ---------- providers ----------

def select_provider():
    options = [(f"p{i}", p["name"]) for i, p in enumerate(PROVIDERS)]
    options.append(("custom", "Custom OpenAI-compatible endpoint"))
    pick = pick_option("Choose a provider", options, default_index=1)
    if pick == "custom":
        base_url = ask("Base URL", "https://api.openai.com/v1")
        model = ask("Model")
        if not model:
            sys.exit("Model required for custom provider")
        env_var = ask("Environment variable", "API_KEY")
        return {
            "name": f"Custom ({model})",
            "base_url": base_url,
            "model": model,
            "env_var": env_var,
            "cache_key": None,
            "price_in": 0.0,
            "price_out": 0.0,
        }
    return PROVIDERS[int(pick[1:])]


# ---------- model selection ----------

def load_model_prices(cache_key):
    """Return {model_id: {price_in, price_out}} from the local opencode cache,
    or {} when the cache is unavailable."""
    if not cache_key or not os.path.exists(MODELS_CACHE):
        return {}
    try:
        with open(MODELS_CACHE, encoding="utf-8") as fh:
            data = json.load(fh)
        provider = data.get(cache_key, {})
        models = provider.get("models", {})
        prices = {}
        for mid, info in models.items():
            cost = info.get("cost") or {}
            prices[mid] = {
                "price_in": cost.get("input", 0.0),
                "price_out": cost.get("output", 0.0),
            }
        return prices
    except Exception:
        return {}


def price_label(prices, mid):
    p = prices.get(mid)
    if not p:
        return ""
    return f"  [dim]${p['price_in']:.3f}/M in · ${p['price_out']:.3f}/M out[/dim]"


def list_models(provider, api_key):
    """Fetch available models via the OpenAI-compatible /models endpoint.
    Returns a list of model ids, or [] on failure."""
    try:
        client = OpenAI(api_key=api_key, base_url=provider["base_url"])
        resp = client.models.list()
        return sorted({m.id for m in resp.data})
    except Exception as exc:
        console.print(
            f"[dim]Could not list models for {provider['name']}:[/] "
            f"[yellow]{type(exc).__name__}[/] — will ask manually."
        )
        return []


def select_model(provider, api_key):
    """Let the user pick a model for the chosen provider, preferring a dynamic
    listing from the provider's /models endpoint."""
    prices = load_model_prices(provider.get("cache_key"))
    ids = list_models(provider, api_key)

    if ids:
        options = [(mid, f"[bold]{mid}[/]{price_label(prices, mid)}") for mid in ids]
        options.append(("__custom__", "[yellow]Type a custom model id[/]"))
        picked = pick_option(f"Choose a model for {provider['name']}", options,
                             default_index=1)
        if picked == "__custom__":
            picked = ask("Model id")
        if not picked:
            sys.exit("No model selected")
        provider["model"] = picked
    else:
        provider["model"] = ask(f"Model id for {provider['name']}", provider["model"])

    if prices and provider["model"] in prices:
        p = prices[provider["model"]]
        provider["price_in"] = p["price_in"]
        provider["price_out"] = p["price_out"]
    console.print(
        f"[dim]✓[/] Using [green]{provider['model']}[/] "
        f"(${provider['price_in']:.3f}/M in · ${provider['price_out']:.3f}/M out)"
    )


# ---------- api key ----------

def get_api_key(provider):
    env = load_env()
    env_var = provider["env_var"]
    if env_var in env and env[env_var]:
        console.print(f"[dim]✓[/] Using API key from [green]{os.path.relpath(ENV_FILE)}[/] ({env_var})")
        return env[env_var], env
    if env_var in os.environ and os.environ[env_var]:
        console.print(f"[dim]✓[/] Using API key from [green]environment[/] ({env_var})")
        return os.environ[env_var], env
    key = ask(f"Paste API key for [bold]{provider['name']}[/]")
    if not key:
        sys.exit("No API key provided")
    if confirm("Save to templates/tools/.env?"):
        env[env_var] = key
        save_env(env)
        console.print(f"[dim]✓[/] Saved [green]{env_var}[/] to {os.path.relpath(ENV_FILE)}")
    return key, env


# ---------- languages / mode ----------

def select_languages(langs):
    codes = list(langs)
    options = [(c, f"[bold]{c}[/]  {LANG_NAMES.get(c, c)}") for c in codes]
    options.append(("new", "[yellow]New language code[/]"))
    picked = pick_multi("Select target language(s)", options)
    if not picked:
        sys.exit("No language selected")
    if "new" in picked:
        code = ask("New language code [dim]e.g. sv[/dim]")
        picked = [c for c in picked if c != "new"] + [code]
    return picked


def select_mode():
    return pick_option(
        "Choose a mode",
        [
            ("full", "Full redo — retranslate everything"),
            ("missing", "Complete missing keys only (keep existing)"),
            ("validate", "Validate only — no API call"),
        ],
        default_index=2,
    )


# ---------- prompt / translation ----------

def build_prompt(lang_code):
    lang_name = LANG_NAMES.get(lang_code, lang_code)
    return (
        f"You are a professional automotive translator. Translate the following "
        f"vehicle maintenance JSON (intervals, parts, and DTC diagnostic trouble "
        f"codes) into {lang_name}. Rules: "
        "1) Keep the JSON keys EXACTLY as-is (no rename, add, or remove). "
        "2) Translate only the values. "
        "3) Do NOT translate technical acronyms/module labels: ECM, PCM, TCM, OBD, "
        "RPM, EGR, EVAP, HO2S, NOx, DPF, B+, A, B, C (circuit labels), 2T, 4WD, etc. "
        "4) Use natural, standard automotive terminology of the target language. "
        "5) Return ONLY the translated JSON, no explanations, no markdown fences."
    )


def translate_batch(client, system, items, model):
    payload = {k: v for k, v in items}
    last_error = None
    for attempt in range(MAX_RETRIES):
        try:
            resp = client.chat.completions.create(
                model=model,
                temperature=0.1,
                response_format={"type": "json_object"},
                messages=[
                    {"role": "system", "content": system},
                    {"role": "user", "content": json.dumps(payload, ensure_ascii=False)},
                ],
            )
            out = json.loads(resp.choices[0].message.content)
            if not isinstance(out, dict) or len(out) != len(payload):
                raise ValueError(
                    f"response has {len(out) if isinstance(out, dict) else '?'} keys, expected {len(payload)}"
                )
            return out
        except Exception as exc:
            last_error = exc
            wait = RETRY_BASE * (2 ** attempt)
            console.print(f"[yellow]  retry {attempt + 1}/{MAX_RETRIES} in {wait}s[/] ({type(exc).__name__})")
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


# ---------- translate ----------

def translate(lang, mode, client, provider, batch_size, progress):
    en = load_en()
    en_keys = list(en.keys())
    dest = os.path.join(I18N_DIR, f"{lang}.json")

    if mode == "missing" and os.path.exists(dest):
        with open(dest, encoding="utf-8") as fh:
            result = json.load(fh)
    else:
        result = {}

    ckpt = load_checkpoint(lang)
    if ckpt:
        merged = dict(result)
        merged.update(ckpt)
        result = merged
        console.print(f"[cyan]↻ Resuming[/] {lang} from checkpoint ({len(ckpt)} keys)")

    todo = [(k, en[k]) for k in en_keys if k not in result]
    total = len(todo)
    if not total:
        console.print(f"[green]✓ {lang}:[/] nothing to translate, already complete")
        validate(lang)
        return

    console.print(f"[bold]{lang}:[/] {total} keys to translate (batch={batch_size})")
    system = build_prompt(lang)
    task = progress.add_task(f"[bold]{lang}[/]", total=total)
    start = time.time()
    for i in range(0, len(todo), batch_size):
        chunk = todo[i:i + batch_size]
        translated = translate_batch(client, system, chunk, provider["model"])
        result.update(translated)
        save_checkpoint(lang, result)
        progress.update(task, advance=len(chunk))
    elapsed = time.time() - start

    missing = [k for k in en_keys if k not in result]
    if missing:
        raise RuntimeError(f"{lang}: {len(missing)} keys still missing: {missing[:10]}")

    write_json(dest, result, en_keys)
    clear_checkpoint(lang)
    progress.remove_task(task)
    console.print(f"[green]✓ {lang}: saved[/] {len(result)} keys → {os.path.relpath(dest)} in {elapsed:.0f}s")


# ---------- main ----------

def main():
    console.print(Panel(HEADER, subtitle=f"source: {os.path.relpath(EN_FILE)}", border_style="cyan"))

    provider = select_provider()
    api_key, env = get_api_key(provider)
    select_model(provider, api_key)
    langs = available_languages()
    targets = select_languages(langs)
    mode = select_mode()

    if mode == "validate":
        console.print()
        for lang in targets:
            validate(lang)
        return

    client = OpenAI(api_key=api_key, base_url=provider["base_url"])

    batch_size = ask("Batch size", str(DEFAULT_BATCH))
    try:
        batch_size = int(batch_size)
    except ValueError:
        batch_size = DEFAULT_BATCH

    en = load_en()
    pending = 0
    for lang in targets:
        dest = os.path.join(I18N_DIR, f"{lang}.json")
        if mode == "missing" and os.path.exists(dest):
            with open(dest, encoding="utf-8") as fh:
                existing = json.load(fh)
        else:
            existing = {}
        ckpt = load_checkpoint(lang)
        existing.update(ckpt)
        pending += sum(1 for k in en if k not in existing)
    total_keys = pending
    tok_in, tok_out, cost = estimate(provider, total_keys)
    console.print(
        Panel(
            f"[bold]Provider:[/] {provider['name']}\n"
            f"[bold]Model:[/] {provider['model']}\n"
            f"[bold]Languages:[/] {', '.join(targets)}\n"
            f"[bold]Keys to translate:[/] {total_keys:,} (of {len(en):,} total per language)\n"
            f"[bold]Estimated tokens:[/] ~{tok_in:,.0f} in / ~{tok_out:,.0f} out\n"
            f"[bold]Estimated cost:[/] [green]${cost:.3f}[/] (approx.)",
            title="Configuration",
            border_style="cyan",
        )
    )

    if not confirm("Proceed"):
        sys.exit("Aborted by user")

    progress = Progress(
        SpinnerColumn(),
        TextColumn("[progress.description]{task.description}"),
        BarColumn(),
        MofNCompleteColumn(),
        TextColumn("{task.percentage:>3.0f}%"),
        TextColumn("({task.completed:,.0f} keys)"),
        TimeElapsedColumn(),
        TimeRemainingColumn(),
        console=console,
    )
    with progress:
        for lang in targets:
            translate(lang, mode, client, provider, batch_size, progress)

    console.print("\n[bold green]✓ All done.[/]")


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        console.print("\n[yellow]Interrupted. Checkpoints are saved — re-run to resume.[/]")
        sys.exit(130)