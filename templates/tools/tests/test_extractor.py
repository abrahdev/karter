import unittest

import _path  # noqa: F401  (sets up sys.path)

from extractor import clean_extracted_data, _slugify, _strip_code_fences


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


if __name__ == "__main__":
    unittest.main()