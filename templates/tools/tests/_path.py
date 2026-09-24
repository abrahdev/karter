"""Central sys.path setup for the templates/tools test suite.

Adds the tools root and each tool subdirectory so modules can be imported by
name (e.g. ``extractor``, ``translate_i18n``) regardless of the working dir.
"""

import os
import sys

TOOLS = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

sys.path.insert(0, TOOLS)
sys.path.insert(0, os.path.join(TOOLS, "generate_from_pdf"))
sys.path.insert(0, os.path.join(TOOLS, "translate_i18n"))
sys.path.insert(0, os.path.join(TOOLS, "import_dtc"))