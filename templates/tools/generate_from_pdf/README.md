# Generate Template from Workshop Manual PDF

AI-powered tool that extracts maintenance data from workshop manual PDFs and generates Karter template JSON files.

## Features

- **PDF Text Extraction**: Reads workshop manuals and extracts text from all pages
- **Language Detection**: Automatically detects PDF language (English, Spanish, German, French, Italian, Portuguese)
- **AI Extraction**: Uses multiple AI providers (OpenAI, Anthropic, Groq, Mistral, etc.) to extract structured data
- **Interactive Review**: Shows extracted data and allows editing before saving
- **Schema Validation**: Validates against Karter template schema (v2)
- **Catalog Regeneration**: Optionally regenerates index.json and karter-catalog.db
- **Batch Processing**: Process multiple PDFs from a folder in one run

## Usage

```bash
python3 templates/tools/generate_from_pdf/generate_from_pdf.py
```

## Workflow

1. **Select Input Mode**: Choose between single PDF file or folder with multiple manuals
2. **Select AI Provider**: Choose from curated list or custom endpoint
3. **For each PDF**:
   - Extract text from all pages
   - Detect language (can be changed)
   - Send text to AI for structured extraction
   - Review extracted data (vehicle info, maintenance items, parts, DTC codes)
   - Edit any section if needed
   - Validate against template schema
   - Save to `templates/data/{make}/{id}.json`
4. **Regenerate Catalog**: Updates index.json and karter-catalog.db (once after all PDFs)

## Extracted Data

The tool extracts:

- **Vehicle Metadata**: Make, model, generation, years, engine specs
- **Maintenance Items**: Oil changes, filters, brakes, etc. with intervals
- **Parts Catalog**: Part names, quantities, units, OEM numbers
- **DTC Codes**: Diagnostic trouble codes with descriptions

## AI Providers

Supports multiple providers via OpenAI-compatible API:

- OpenCode Go (deepseek-v4-flash)
- DeepSeek (deepseek-chat)
- OpenAI (gpt-4o-mini)
- Anthropic (claude-haiku)
- Groq (llama-3.3-70b)
- Mistral (mistral-small)
- OpenRouter (auto)
- Custom OpenAI-compatible endpoints

## Dependencies

```bash
pip install -r templates/tools/requirements.txt
```

Required packages:
- `pymupdf` - PDF parsing
- `openai` - AI client
- `rich` - Terminal UI
- `jsonschema` - Schema validation

## Example Output

```
▍ karter template generator

Select input mode:
[1] Single PDF file
[2] Folder with multiple manuals (batch)
Select [1]:

PDF file path: workshop-manual.pdf
✓ PDF loaded: 45 pages

Choose a provider:
[1] OpenAI (gpt-4o-mini)
[2] Anthropic (claude-haiku)
...
Select [1]:

Detected language: English
[1] English
[2] Spanish
[3] German
...
Select [1]:

Extracting text from PDF... [████████████████] 100%
✓ Extracted 125,432 characters

Analyzing with AI... [████████████████] 100%
✓ Extraction complete

============================================================
EXTRACTED DATA
============================================================

Vehicle: Toyota Corolla E210
Generation: E210
Years: 2019-present
Engine: M20A-FKS, 2.0L, 169HP, gasoline

Maintenance Items (8):
  • Oil change: 15,000 km / 12 months
  • Air filter: 30,000 km / 24 months
  • Brake pads (front): 60,000 km
  ...

Parts (23):
  • oil-filter: 1 unit
  • engine-oil-5w30: 4.2 L
  ...

============================================================

[1] Accept and save
[2] Edit vehicle info
[3] Edit maintenance items
...
Select [1]:

✓ Template saved to templates/data/toyota/corolla-e210.json
✓ All validations passed

Regenerate index.json and karter-catalog.db? [Y/n]: y
✓ Catalog regenerated

✓ All done!
```

## Batch Processing

When processing a folder with multiple manuals:

1. Select "Folder with multiple manuals" at the start
2. Provide the folder path
3. The tool lists all PDF files found (recursively)
4. Confirm to process all files
5. Each PDF is processed sequentially with the same AI provider
6. You can skip individual PDFs during review
7. After all PDFs are processed, regenerate the catalog once

**Tips for batch processing:**
- Use a consistent folder structure for better organization
- The tool handles errors gracefully and continues with the next PDF
- You can interrupt with Ctrl+C and the catalog won't be regenerated
- Review each extraction carefully, especially in batch mode

## Notes

- AI extraction is not perfect; always review the data before saving
- The tool works best with well-structured workshop manuals
- Language detection is basic; manual override is available
- Large PDFs (>100 pages) may be truncated due to AI context limits
- Generated templates should be manually reviewed for accuracy
