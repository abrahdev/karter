"""PDF text extraction for workshop manuals."""

import sys
from pathlib import Path

try:
    import pymupdf as fitz
except ImportError:
    sys.exit("Missing dependency: run  pip install pymupdf  first")


class PDFReader:
    """Extract text from PDF files."""

    def __init__(self, pdf_path: str):
        self.pdf_path = Path(pdf_path)
        if not self.pdf_path.exists():
            raise FileNotFoundError(f"PDF not found: {pdf_path}")
        if not self.pdf_path.suffix.lower() == ".pdf":
            raise ValueError(f"Not a PDF file: {pdf_path}")

    def extract_text(self, pages: list[int] | None = None) -> str:
        """Extract text from PDF pages.

        Args:
            pages: List of page numbers (0-indexed). If None, extract all pages.

        Returns:
            Concatenated text from all pages.
        """
        doc = fitz.open(self.pdf_path)
        try:
            if pages is None:
                pages = range(len(doc))

            text_parts = []
            for page_num in pages:
                if page_num >= len(doc):
                    continue
                page = doc[page_num]
                text = page.get_text()
                if text.strip():
                    text_parts.append(f"\n--- Page {page_num + 1} ---\n{text}")

            return "\n".join(text_parts)
        finally:
            doc.close()

    def get_page_count(self) -> int:
        """Return the number of pages in the PDF."""
        doc = fitz.open(self.pdf_path)
        try:
            return len(doc)
        finally:
            doc.close()

    def extract_page(self, page_num: int) -> str:
        """Extract text from a single page (0-indexed)."""
        return self.extract_text([page_num])

    def detect_language(self) -> str:
        """Basic language detection based on common words.

        Returns:
            Language code (en, es, de, fr, etc.)
        """
        # Extract first few pages for language detection
        sample = self.extract_text(list(range(min(5, self.get_page_count()))))
        sample_lower = sample.lower()

        # Common words per language
        indicators = {
            "en": ["the", "and", "is", "in", "to", "of", "a", "that", "it"],
            "es": ["el", "la", "de", "que", "y", "en", "un", "ser", "por"],
            "de": ["der", "die", "das", "und", "ist", "von", "zu", "den", "mit"],
            "fr": ["le", "la", "de", "et", "est", "un", "une", "des", "du"],
            "it": ["il", "la", "di", "che", "è", "un", "una", "per", "sono"],
            "pt": ["o", "a", "de", "que", "e", "em", "um", "para", "com"],
        }

        scores = {}
        for lang, words in indicators.items():
            score = sum(sample_lower.count(word) for word in words)
            scores[lang] = score

        # Return language with highest score
        if scores:
            return max(scores, key=scores.get)
        return "en"
