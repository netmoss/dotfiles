#!/bin/bash

set -e

if [ -z "$1" ]; then
  printf "Usage: to-pdf <file.md>\n"
  exit 1
fi

INPUT="$1"

if [ ! -f "$INPUT" ]; then
  printf "Error: File '%s' not found.\n" "$INPUT"
  exit 1
fi

if [[ ! "$INPUT" =~ \.md$ ]]; then
  printf "Error: Input must be a Markdown (.md) file.\n"
  exit 1
fi

OUTPUT="${INPUT%.md}.pdf"

if pandoc "$INPUT" -f markdown+lists_without_preceding_blankline -o "$OUTPUT" --pdf-engine=tectonic; then
  printf "Successfully created PDF: %s\n" "$OUTPUT"
else
  printf "Failed to generate PDF.\n"
  exit 1
fi

