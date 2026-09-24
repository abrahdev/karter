"""Optional live smoke tests against the OpenCode Go API.

Skipped unless the KARTER_SMOKE environment variable is set to a truthy
value. They make real (paid) API calls, so they are intentionally not part
of the default test run:

    KARTER_SMOKE=1 python -m unittest \
        templates/tools/tests/test_smoke_api.py

The API key is read from the OPENCODE_API_KEY environment variable or from
templates/tools/.env.
"""

import json
import os
import unittest

import _path  # noqa: F401  (sets up sys.path)

from _shared import create_client
from extractor import extract_with_ai
import translate_i18n as ti

TOOLS = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ENV_FILE = os.path.join(TOOLS, ".env")
EN_FILE = os.path.join(TOOLS, "..", "i18n", "en.json")

BASE_URL = "https://opencode.ai/zen/go/v1"
MODEL = "deepseek-v4-flash"

SYNTHETIC_MANUAL = (
    "Toyota Corolla E210 1.8 hybrid. Oil change every 15000 km or 12 months. "
    "Replace the engine oil filter at the same time. Air filter every 30000 km. "
    "Brake fluid every 40000 km or 2 years. Spark plugs every 60000 km. "
    "Check the hybrid battery cooling filter every 30000 km. "
    "Engine oil: 0W-16, 3.9 liters."
)


def _api_key():
    key = os.environ.get("OPENCODE_API_KEY")
    if key:
        return key.strip()
    if os.path.exists(ENV_FILE):
        with open(ENV_FILE, encoding="utf-8") as fh:
            for line in fh:
                line = line.strip()
                if line.startswith("OPENCODE_API_KEY="):
                    return line.split("=", 1)[1].strip()
    return None


def _load_en():
    with open(os.path.normpath(EN_FILE), encoding="utf-8") as fh:
        return json.load(fh)


@unittest.skipUnless(
    os.environ.get("KARTER_SMOKE") in ("1", "true", "yes"),
    "set KARTER_SMOKE=1 to run live API smoke tests",
)
class SmokeApiTest(unittest.TestCase):
    def setUp(self):
        key = _api_key()
        if not key:
            self.skipTest("OPENCODE_API_KEY not available")
        self.client = create_client(
            {"base_url": BASE_URL, "model": MODEL}, key, timeout=120
        )

    def test_probe_endpoint_responds(self):
        from extractor import _probe_endpoint

        self.assertTrue(_probe_endpoint(self.client, MODEL))

    def test_translate_batch_roundtrip(self):
        en = _load_en()
        items = list(en.items())[:4]
        system = ti.build_prompt("es")
        out = ti.translate_batch(self.client, system, items, MODEL)
        self.assertEqual(set(out), set(k for k, _ in items))
        self.assertTrue(all(v for v in out.values()))

    def test_extract_with_ai_returns_structured_data(self):
        data, raw = extract_with_ai(
            self.client, MODEL, SYNTHETIC_MANUAL, "en", max_tokens=1500
        )
        self.assertIn("id", data)
        self.assertIn("meta", data)
        self.assertTrue(raw)

    def test_extract_with_ai_large_text(self):
        # Reproduces the reported hang: a big manual text through the full
        # probe + streaming + fail-fast pipeline.
        big = SYNTHETIC_MANUAL * 40
        data, raw = extract_with_ai(self.client, MODEL, big, "en", max_tokens=1500)
        self.assertIn("id", data)
        self.assertIn("meta", data)


if __name__ == "__main__":
    unittest.main()