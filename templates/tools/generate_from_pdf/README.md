# Generate Template from Workshop Manual PDF

AI-powered tool that extracts maintenance data from workshop manual PDFs and generates Karter template JSON files.

## Features

- **PDF Text Extraction**: Reads workshop manuals and extracts text from all pages
- **Language Detection**: Automatically detects PDF language (English, Spanish, German, French, Italian, Portuguese)
- **Manual Text Preview**: Optionally view the extracted text before it is sent to the AI
- **Fail-Fast AI Extraction**: a tiny liveness probe runs first, an attempt fails after 180s without a first token, and SDK auto-retries are disabled — no silent multi-minute hangs
- **Null Cleanup**: extracted `null` values are omitted automatically (the schema rejects `null` for string/integer fields), so saved JSON validates on the first try
- **AI Extraction**: Uses multiple AI providers (OpenAI, Anthropic, Groq, Mistral, etc.) to extract structured data
- **Interactive Review**: Shows the complete extracted data (items, parts, DTCs are never truncated) and allows editing before saving
- **Schema Validation**: Validates against Karter template schema (v2); every maintenance item must have a positive `interval_km`
- **Duplicate-ID Protection**: Saving refuses to overwrite an existing template id
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
   - Optionally preview the extracted manual text before sending it
   - Send text to AI for structured extraction (endpoint probe + streaming timer)
   - Review the full extracted data (vehicle info, maintenance items, parts, DTC codes)
   - Edit any section if needed
   - Validate against the template schema (each item needs a positive `interval_km`)
   - Save to `templates/data/{make}/{id}.json` (duplicate ids are flagged)
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
✓ Extracted 125,432 characters (~31,000 tokens)
View extracted manual text before sending to AI? (y/N): y

Analyzing with AI...
  Streaming the response below; large manuals can take 1-3 minutes.
  Probing endpoint (deepseek-v4-flash)…
  ✓ endpoint responding (3.2s)
  Attempt 1/5 · deepseek-v4-flash · json_object=True · 125,432 chars
  waiting for the AI response… 12s
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
  • ... (all items are listed)

Parts (23):
  • oil-filter: 1 unit
  • engine-oil-5w30: 4.2 L
  • ... (all parts are listed)

============================================================

[1] Accept and save
[2] Edit vehicle info
[3] Edit maintenance items
[4] Edit parts
[5] Edit DTC codes
[6] View raw AI response
[7] View extracted manual text
[8] Skip this PDF
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
- Every maintenance item must include a positive `interval_km` (the catalog requires it); items with only `interval_months` are rejected at review time
- Saving refuses to overwrite an existing template id — rename the template or delete the old file
- Extracted `null` values are omitted automatically before saving; `meta.years` keeps the `[start, null]` form
- A stuck endpoint no longer hangs silently: the liveness probe warns fast, and an attempt fails after 180s without a first token
- Generated templates should be manually reviewed for accuracy
