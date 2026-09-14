import json
import os
import tempfile
import unittest
from types import SimpleNamespace as NS

import _path  # noqa: F401  (sets up sys.path)

import translate_i18n as ti


def fake_client(content):
    """OpenAI-compatible client stub returning a fixed JSON string.

    Supports both streaming and non-streaming create() calls.
    """
    choice = NS(message=NS(content=content))

    def create(**kwargs):
        if kwargs.get("stream"):
            def gen():
                delta = NS(content=content)
                yield NS(choices=[NS(delta=delta)])
            return gen()
        return NS(choices=[choice])

    return NS(chat=NS(completions=NS(create=create)))


def provider(**overrides):
    p = {
        "name": "Fake",
        "model": "fake-model",
        "price_in": 1.0,
        "price_out": 2.0,
    }
    p.update(overrides)
    return p


class AbortTest(unittest.TestCase):
    def test_abort_returns_value(self):
        self.assertEqual(ti.abort("x"), "x")

    def test_abort_exits_on_back(self):
        with self.assertRaises(SystemExit):
            ti.abort(ti.BACK)


class EstimateTest(unittest.TestCase):
    def test_token_math(self):
        tok_in, tok_out, cost = ti.estimate(provider(), 100)
        self.assertEqual(tok_in, 100 * ti.TOKENS_PER_KEY)
        self.assertAlmostEqual(tok_out, 100 * ti.TOKENS_PER_KEY * 0.6)
        self.assertGreater(cost, 0)


class BuildPromptTest(unittest.TestCase):
    def test_placeholder_replaced(self):
        prompt = ti.build_prompt("es")
        self.assertIn("Spanish", prompt)
        self.assertNotIn("{lang_name}", prompt)


class TranslateBatchTest(unittest.TestCase):
    def setUp(self):
        # No sleeping between retries in tests.
        self._retries = ti.MAX_RETRIES
        self._base = ti.RETRY_BASE
        ti.MAX_RETRIES = 2
        ti.RETRY_BASE = 0

    def tearDown(self):
        ti.MAX_RETRIES = self._retries
        ti.RETRY_BASE = self._base

    def test_returns_translated_keys(self):
        items = [("k1", "one"), ("k2", "two")]
        out = {"k1": "uno", "k2": "dos"}
        client = fake_client(json.dumps(out))
        result = ti.translate_batch(client, "system", items, "m")
        self.assertEqual(result, out)

    def test_rejects_missing_key(self):
        items = [("k1", "one"), ("k2", "two")]
        client = fake_client(json.dumps({"k1": "uno"}))
        with self.assertRaises(RuntimeError):
            ti.translate_batch(client, "system", items, "m")

    def test_rejects_extra_key(self):
        items = [("k1", "one")]
        client = fake_client(json.dumps({"k1": "uno", "k3": "x"}))
        with self.assertRaises(RuntimeError):
            ti.translate_batch(client, "system", items, "m")

    def test_rejects_non_object(self):
        items = [("k1", "one")]
        client = fake_client("[1, 2, 3]")
        with self.assertRaises(RuntimeError):
            ti.translate_batch(client, "system", items, "m")


class LoadResultTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self._i18n = ti.I18N_DIR
        self._ckpt = ti.CKPT_DIR
        ti.I18N_DIR = self.tmp.name
        ti.CKPT_DIR = os.path.join(self.tmp.name, "ckpt")

    def tearDown(self):
        ti.I18N_DIR = self._i18n
        ti.CKPT_DIR = self._ckpt
        self.tmp.cleanup()

    def _write(self, path, data):
        path = os.path.join(self.tmp.name, path)
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, "w", encoding="utf-8") as fh:
            json.dump(data, fh)

    def test_missing_mode_loads_dest(self):
        self._write("es.json", {"a": "uno"})
        self.assertEqual(ti.load_result("es", "missing"), {"a": "uno"})

    def test_full_mode_ignores_dest(self):
        self._write("es.json", {"a": "uno"})
        self.assertEqual(ti.load_result("es", "full"), {})

    def test_checkpoint_merged(self):
        self._write("es.json", {"a": "uno"})
        self._write(os.path.join("ckpt", "es.json"), {"b": "dos"})
        self.assertEqual(
            ti.load_result("es", "missing"), {"a": "uno", "b": "dos"}
        )


if __name__ == "__main__":
    unittest.main()