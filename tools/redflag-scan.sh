#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   cat file.txt | ./tools/redflag-scan.sh
#   ./tools/redflag-scan.sh file.txt
#
# Flags potential sensitive patterns (best-effort).

input="${1:-/dev/stdin}"

echo "[redflag-scan] scanning: ${1:-stdin}" >&2

grep -nE \
'([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}|\b([0-9]{1,3}\.){3}[0-9]{1,3}\b|/home/[^/[:space:]]+|\bUUID\b|\bSerial\b' \
"$input" || true
