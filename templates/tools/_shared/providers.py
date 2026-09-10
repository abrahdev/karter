"""AI provider management for Karter template tools."""

import json
import os
import sys

from rich.console import Console

try:
    from openai import OpenAI
except ImportError:
    sys.exit("Missing dependency: run  pip install openai  first")

from .ui import ask, confirm, pick_option

console = Console()

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
ENV_FILE = os.path.join(os.path.dirname(__file__), "..", ".env")
MODELS_CACHE = os.path.join(os.path.expanduser("~"), ".cache", "opencode", "models.json")

# Curated provider list. Each entry: base_url, model, env var, and per-1M
# token prices (input/output, USD) used for the cost estimate. Prices are
# approximations; edit freely. cache_key maps to the provider id used in the
# local models.json cache (when available) for dynamic prices.
PROVIDERS = [
    {
        "name": "OpenCode Go",
        "base_url": "https://opencode.ai/zen/go/v1",
        "model": "deepseek-v4-flash",
        "env_var": "OPENCODE_API_KEY",
        "cache_key": "opencode-go",
        "price_in": 0.2,
        "price_out": 0.5,
    },
    {
        "name": "DeepSeek",
        "base_url": "https://api.deepseek.com",
        "model": "deepseek-chat",
        "env_var": "DEEPSEEK_API_KEY",
        "cache_key": "deepseek",
        "price_in": 0.27,
        "price_out": 1.10,
    },
    {
        "name": "OpenAI",
        "base_url": "https://api.openai.com/v1",
        "model": "gpt-4o-mini",
        "env_var": "OPENAI_API_KEY",
        "cache_key": "openai",
        "price_in": 0.15,
        "price_out": 0.60,
    },
    {
        "name": "Anthropic",
        "base_url": "https://api.anthropic.com/v1",
        "model": "claude-haiku-4-5-20251001",
        "env_var": "ANTHROPIC_API_KEY",
        "cache_key": "anthropic",
        "price_in": 1.0,
        "price_out": 5.0,
    },
    {
        "name": "Groq",
        "base_url": "https://api.groq.com/openai/v1",
        "model": "llama-3.3-70b-versatile",
        "env_var": "GROQ_API_KEY",
        "cache_key": "groq",
        "price_in": 0.59,
        "price_out": 0.79,
    },
    {
        "name": "Mistral",
        "base_url": "https://api.mistral.ai/v1",
        "model": "mistral-small-latest",
        "env_var": "MISTRAL_API_KEY",
        "cache_key": "mistral",
        "price_in": 0.1,
        "price_out": 0.3,
    },
    {
        "name": "OpenRouter",
        "base_url": "https://openrouter.ai/api/v1",
        "model": "openrouter/auto",
        "env_var": "OPENROUTER_API_KEY",
        "cache_key": "openrouter",
        "price_in": 0.15,
        "price_out": 0.60,
    },
]


def load_env():
    """Load environment variables from .env file."""
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
    """Save environment variables to .env file."""
    lines = [f"{k}={v}" for k, v in env.items()]
    with open(ENV_FILE, "w", encoding="utf-8") as fh:
        fh.write("\n".join(lines) + "\n")


def select_provider():
    """Interactive provider selection."""
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
    """Format price label for display."""
    p = prices.get(mid)
    if not p:
        return ""
    return f"  ${p['price_in']:.3f}/M in · ${p['price_out']:.3f}/M out"


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
        options = [(mid, f"{mid}{price_label(prices, mid)}") for mid in ids]
        options.append(("__custom__", "Type a custom model id"))
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


def get_api_key(provider):
    """Get API key from .env, environment, or user input."""
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
