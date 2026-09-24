import unittest

import _path  # noqa: F401  (sets up sys.path)

from import_dtc import parse_codes


class ParseCodesTest(unittest.TestCase):
    def test_parses_valid_lines(self):
        text = (
            "# comment\n"
            "P0171 - System too lean\n"
            "B1000 - Body code\n"
        )
        self.assertEqual(
            list(parse_codes(text)),
            [("P0171", "System too lean"), ("B1000", "Body code")],
        )

    def test_skips_malformed_and_duplicates(self):
        text = (
            "not a valid line\n"
            "P0171 - First\n"
            "P0171 - Duplicate\n"
            "P0172\n"
            "X1234 - Bad prefix\n"
        )
        self.assertEqual(list(parse_codes(text)), [("P0171", "First")])

    def test_empty_input(self):
        self.assertEqual(list(parse_codes("  \n\n")), [])


if __name__ == "__main__":
    unittest.main()