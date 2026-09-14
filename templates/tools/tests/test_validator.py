import unittest

import _path  # noqa: F401  (sets up sys.path)

from validator import validate_post_merge


def valid_item(**overrides):
    item = {
        "id": "oil-change",
        "label": "Oil change",
        "interval_km": 15000,
        "interval_months": 12,
        "description": "Change the engine oil.",
    }
    item.update(overrides)
    return item


class ValidatePostMergeTest(unittest.TestCase):
    def test_valid_data_passes(self):
        data = {
            "meta": {"years": [2010, 2020]},
            "parts": [{"id": "p1"}, {"id": "p2"}],
            "maintenance_items": [valid_item(), valid_item(id="air-filter")],
            "obd_dtc_definitions": [{"code": "P0171"}, {"code": "P0172"}],
        }
        self.assertEqual(validate_post_merge(data), [])

    def test_duplicate_part_ids(self):
        data = {"parts": [{"id": "p1"}, {"id": "p1"}]}
        errors = validate_post_merge(data)
        self.assertEqual(len(errors), 1)
        self.assertEqual(errors[0]["validator"], "uniqueItems")
        self.assertIn("parts", errors[0]["path"])

    def test_duplicate_item_ids(self):
        data = {"maintenance_items": [valid_item(), valid_item()]}
        errors = validate_post_merge(data)
        self.assertEqual(len(errors), 1)
        self.assertIn("maintenance_items", errors[0]["path"])

    def test_duplicate_dtc_codes(self):
        data = {"obd_dtc_definitions": [{"code": "P0171"}, {"code": "P0171"}]}
        errors = validate_post_merge(data)
        self.assertEqual(len(errors), 1)
        self.assertIn("obd_dtc_definitions", errors[0]["path"])

    def test_none_ids_not_duplicates(self):
        data = {"parts": [{"name": "a"}, {"name": "b"}]}
        self.assertEqual(validate_post_merge(data), [])

    def test_year_ordering(self):
        data = {"meta": {"years": [2025, 2020]}}
        errors = validate_post_merge(data)
        self.assertEqual(len(errors), 1)
        self.assertEqual(errors[0]["validator"], "yearOrder")

    def test_interval_km_min(self):
        data = {"maintenance_items": [valid_item(interval_km=0)]}
        errors = validate_post_merge(data)
        self.assertEqual(len(errors), 1)
        self.assertEqual(errors[0]["validator"], "minimum")

    def test_missing_interval_km(self):
        data = {"maintenance_items": [valid_item(interval_km=None)]}
        errors = validate_post_merge(data)
        self.assertEqual(len(errors), 1)
        self.assertEqual(errors[0]["validator"], "minimum")

    def test_interval_months_min(self):
        data = {"maintenance_items": [valid_item(interval_months=0)]}
        errors = validate_post_merge(data)
        self.assertEqual(len(errors), 1)
        self.assertEqual(errors[0]["validator"], "minimum")


if __name__ == "__main__":
    unittest.main()