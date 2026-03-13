#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

mkdir -p reports
report_file="reports/redflag-report.txt"

timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

{
  echo "redflag repository report"
  echo "generated_at: $timestamp"
  echo "repository: $(basename "$repo_root")"
  echo
  echo "scanned_files:"
} > "$report_file"

found=0

while IFS= read -r file; do
  echo "  - $file" >> "$report_file"

  if ./tools/redflag-scan.sh --fail "$file" >/dev/null 2>&1; then
    echo "[ok] $file"
    {
      echo
      echo "[$file]"
      echo "status: clean"
    } >> "$report_file"
  else
    code=$?
    if [[ "$code" -eq 2 ]]; then
      echo "[match] $file"
      {
        echo
        echo "[$file]"
        echo "status: flagged"
        echo "matches:"
      } >> "$report_file"

      ./tools/redflag-scan.sh "$file" \
        | sed 's/^/  /' >> "$report_file" || true

      found=1
    else
      echo "[warn] scanner error on $file"
      {
        echo
        echo "[$file]"
        echo "status: scanner-error"
      } >> "$report_file"
      found=1
    fi
  fi
done < <(
  git ls-files \
    | grep -E '\.(md|txt|sh|yml|yaml|json)$' \
    | grep -vE '^tools/patterns/|^examples/' || true
)

echo
echo "report written to: $report_file"

if [[ "$found" -eq 1 ]]; then
  echo "summary: review flagged entries in $report_file"
  exit 1
fi

echo "summary: no obvious sensitive patterns found"
exit 0
