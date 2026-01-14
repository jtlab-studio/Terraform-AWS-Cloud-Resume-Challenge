#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <file.tf>"
  exit 1
fi

INPUT_FILE="$1"

if [ ! -f "$INPUT_FILE" ]; then
  echo "File not found: $INPUT_FILE"
  exit 1
fi

BASENAME="$(basename "$INPUT_FILE")"
DIRNAME="$(dirname "$INPUT_FILE")"
OUTPUT_FILE="${DIRNAME}/${BASENAME%.tf}_cleaned.tf"

# Replace any line that looks like: key = value
# Keep everything up to and including '='
# Replace the value with "PLACEHOLDER"
sed -E \
  's/^([[:space:]]*[A-Za-z0-9_]+[[:space:]]*=[[:space:]]*).*/\1"PLACEHOLDER"/' \
  "$INPUT_FILE" > "$OUTPUT_FILE"

echo "Cleaned file written to: $OUTPUT_FILE"

