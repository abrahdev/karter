import unittest
from types import SimpleNamespace as NS
from unittest import mock

import _path  # noqa: F401  (sets up sys.path)

import extractor as ex
from extractor import _slugify, _strip_code_fences, clean_extracted_data


class SlugifyTest(unittest.TestCase):
    def test_basic_slug(self):
        self.assertEqual(_slugify("Oil Change"), "oil-change")

    def test_strips_illegal_chars(self):
        self.assertEqual(_slugify("Toyota Corolla E210!!"), "toyota-corolla-e210")

    def test_collapses_dashes(self):
        self.assertEqual(_slugify("P--O 17 1!"), "p-o-17-1")

    def test_empty_ok(self):
        self.assertEqual(_slugify("???"), "")


class StripCodeFencesTest(unittest.TestCase):
    def test_strips_fenced_json(self):
        raw = "```json\n{\"id\": \"x\"}\n```"
        self.assertEqual(_strip_code_fences(raw), '{"id": "x"}')

    def test_keeps_plain_json(self):
        raw = '{"id": "x"}'
        self.assertEqual(_strip_code_fences(raw), raw)

    def test_strips_unfenced_lang_tag(self):
        raw = "```\n{\"id\": \"x\"}\n```"
        self.assertEqual(_strip_code_fences(raw), '{"id": "x"}')


class CleanExtractedDataTest(unittest.TestCase):
    def test_slugs_ids_and_drops_empty_arrays(self):
        data = {
            "id": "Toyota Corolla!",
            "parts": [{"id": "Oil Filter A", "name": "f"}],
            "maintenance_items": [],
            "obd_dtc_definitions": [],
        }
        cleaned = clean_extracted_data(data)
        self.assertEqual(cleaned["id"], "toyota-corolla")
        self.assertEqual(cleaned["parts"][0]["id"], "oil-filter-a")
        self.assertNotIn("maintenance_items", cleaned)
        self.assertNotIn("obd_dtc_definitions", cleaned)

    def test_no_ids_is_noop(self):
        data = {"meta": {"make": "x"}}
        self.assertEqual(clean_extracted_data(data), data)

    def test_drops_null_fields(self):
        data = {
            "id": "Toyota Corolla",
            "meta": {"make": "Toyota", "generation": None, "years": [2020, None]},
            "parts": [{"id": "Oil Filter", "oem_number": None, "name": "Filter"}],
            "maintenance_items": [
                {"id": "Oil Change", "interval_km": 15000, "interval_months": None}
            ],
        }
        cleaned = clean_extracted_data(data)
        self.assertNotIn("generation", cleaned["meta"])
        self.assertEqual(cleaned["meta"]["years"], [2020, None])
        self.assertNotIn("oem_number", cleaned["parts"][0])
        self.assertNotIn("interval_months", cleaned["maintenance_items"][0])
        self.assertEqual(cleaned["maintenance_items"][0]["interval_km"], 15000)


class RenderLiveTest(unittest.TestCase):
    def test_shows_elapsed_when_empty(self):
        panel = ex._render_live([], 42)
        self.assertIn("42s", panel.renderable)

    def test_shows_content_when_available(self):
        panel = ex._render_live(["hello world"], 3)
        self.assertIn("hello world", panel.renderable)


def _fake_client(stream):
    def create(**kwargs):
        return stream

    return NS(chat=NS(completions=NS(create=create)))


class _FakeDelta:
    content = None


class _FakeChunk:
    choices = [NS(delta=_FakeDelta())]


class StreamContentTest(unittest.TestCase):
    def test_returns_joined_content(self):
        chunks = [NS(choices=[NS(delta=NS(content=t))]) for t in "abc"]
        out = ex._stream_content(_fake_client(iter(chunks)), {"model": "m"}, timeout=5)
        self.assertEqual(out, "abc")

    def test_raises_timeout_when_no_first_token(self):
        # monotonic: start, then per-chunk elapsed values, last one past the cap.
        times = iter([0.0, 0.0, 0.0, ex.FIRST_TOKEN_TIMEOUT + 1])
        client = _fake_client((_FakeChunk() for _ in range(3)))
        with mock.patch.object(
            ex.time, "monotonic", side_effect=lambda: next(times)
        ):
            with self.assertRaises(TimeoutError):
                ex._stream_content(client, {"model": "m"})


class ProbeEndpointTest(unittest.TestCase):
    def test_success(self):
        client = NS(chat=NS(completions=NS(create=lambda **kw: NS())))
        self.assertTrue(ex._probe_endpoint(client, "m"))

    def test_failure(self):
        def create(**kwargs):
            raise ConnectionError("boom")

        client = NS(chat=NS(completions=NS(create=create)))
        self.assertFalse(ex._probe_endpoint(client, "m"))


if __name__ == "__main__":
    unittest.main()