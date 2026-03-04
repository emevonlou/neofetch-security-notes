#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./tools/redflag-scan.sh [--fail] [file]
#   cat file.txt | ./tools/redflag-scan.sh [--fail]
#
# Scans text for common sensitive patterns (best-effort).
# By default, exits 0 even if matches are found.
# With --fail, exits 2 if matches are found (useful for CI).

FAIL=0
if [[ "${1:-}" == "--fail" ]]; then
  FAIL=1
  shift
fi

input="${1:-/dev/stdin}"
patterns="tools/patterns/redflags.regex"

if [[ ! -f "$patterns" ]]; then
  echo "[redflag-scan] missing patterns file: $patterns" >&2
  exit 1
fi

echo "[redflag-scan] scanning: ${1:-stdin}" >&2

# Build a single regex from the patterns file:
# - drop comments/blank lines
# - join with |
regex="$(grep -vE '^\s*#|^\s*$' "$patterns" | paste -sd'|' -)"

matches="$(grep -nE "$regex" "$input" || true)"

if [[ -z "$matches" ]]; then
  echo "[redflag-scan] no obvious sensitive patterns found" >&2
  exit 0
fi

echo "$matches"

if [[ "$FAIL" -eq 1 ]]; then
  exit 2
fi

exit 0
