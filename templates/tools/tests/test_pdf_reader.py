import tempfile
import unittest
from pathlib import Path

import _path  # noqa: F401  (sets up sys.path)

import pymupdf as fitz

from pdf_reader import PDFReader

EN_TEXT = (
    "The engine and the oil filter are easy to replace. To change the oil "
    "and the air filter you must read the manual. The car is in the shop "
    "and the mechanic will check the brakes. This is the first inspection."
)

ES_TEXT = (
    "El motor y el filtro de aceite son fáciles de reemplazar. Para cambiar "
    "el aceite y el filtro de aire debe leer el manual. El coche está en el "
    "taller y el mecánico revisará los frenos. Es la primera inspección."
)


def make_pdf(path: Path, texts):
    doc = fitz.open()
    for text in texts:
        page = doc.new_page()
        page.insert_text((72, 72), text)
    doc.save(path)
    doc.close()


class PDFReaderTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.pdf = Path(self.tmp.name) / "manual.pdf"

    def tearDown(self):
        self.tmp.cleanup()

    def test_get_page_count(self):
        make_pdf(self.pdf, [EN_TEXT, ES_TEXT])
        self.assertEqual(PDFReader(self.pdf).get_page_count(), 2)

    def test_extract_text_marks_pages(self):
        make_pdf(self.pdf, [EN_TEXT, ES_TEXT])
        text = PDFReader(self.pdf).extract_text()
        self.assertIn("--- Page 1 ---", text)
        self.assertIn("--- Page 2 ---", text)
        self.assertIn("engine", text)

    def test_extract_page_single(self):
        make_pdf(self.pdf, [EN_TEXT, ES_TEXT])
        self.assertIn("motor", PDFReader(self.pdf).extract_page(1))

    def test_detect_language_english(self):
        make_pdf(self.pdf, [EN_TEXT])
        self.assertEqual(PDFReader(self.pdf).detect_language(), "en")

    def test_detect_language_spanish(self):
        make_pdf(self.pdf, [ES_TEXT])
        self.assertEqual(PDFReader(self.pdf).detect_language(), "es")

    def test_missing_file_raises(self):
        with self.assertRaises(FileNotFoundError):
            PDFReader(Path(self.tmp.name) / "nope.pdf")


if __name__ == "__main__":
    unittest.main()