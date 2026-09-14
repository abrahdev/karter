import unittest
from unittest import mock

import _path  # noqa: F401  (sets up sys.path)

from _shared import providers
from _shared.ui import BACK


def make_provider():
    return {
        "name": "Fake",
        "base_url": "https://example.invalid/v1",
        "model": "old-model",
        "env_var": "FAKE_API_KEY",
        "cache_key": None,
        "price_in": 0.0,
        "price_out": 0.0,
    }


class SelectModelTest(unittest.TestCase):
    def test_returns_true_on_success(self):
        provider = make_provider()
        with mock.patch.object(providers, "list_models", return_value=["m1", "m2"]), \
                mock.patch.object(providers, "pick_option", return_value="m2"):
            self.assertTrue(providers.select_model(provider, "key"))
        self.assertEqual(provider["model"], "m2")

    def test_returns_false_on_back(self):
        provider = make_provider()
        with mock.patch.object(providers, "list_models", return_value=["m1"]), \
                mock.patch.object(providers, "pick_option", return_value=BACK):
            self.assertFalse(providers.select_model(provider, "key"))

    def test_returns_false_on_custom_back(self):
        provider = make_provider()
        with mock.patch.object(providers, "list_models", return_value=["m1"]), \
                mock.patch.object(providers, "pick_option", return_value="__custom__"), \
                mock.patch.object(providers, "ask", return_value=BACK):
            self.assertFalse(providers.select_model(provider, "key"))

    def test_manual_model_when_no_listing(self):
        provider = make_provider()
        with mock.patch.object(providers, "list_models", return_value=[]), \
                mock.patch.object(providers, "ask", return_value="manual-model"):
            self.assertTrue(providers.select_model(provider, "key"))
        self.assertEqual(provider["model"], "manual-model")


if __name__ == "__main__":
    unittest.main()