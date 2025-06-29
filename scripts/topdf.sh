#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: to-pdf <file.md>"
  exit 1
fi

INPUT="$1"

if [ ! -f "$INPUT" ]; then
  echo "Error: File '$INPUT' not found."
  exit 1
fi

if [[ "$INPUT" != *.md ]]; then
  echo "Error: Input must be a Markdown (.md) file."
  exit 1
fi

OUTPUT="${INPUT%.md}.pdf"

pandoc "$INPUT" -o "$OUTPUT" --pdf-engine=tectonic

if [ $? -eq 0 ]; then
  echo "Successfully created PDF: $OUTPUT"
else
  echo "Failed to generate PDF."
fi

