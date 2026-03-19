#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

echo "[1/4] checking tool permissions"
chmod +x tools/*.sh hooks/pre-commit || true

echo "[2/4] running red-flag scan on repository text files"
found=0
while IFS= read -r f; do
  if ./tools/redflag-scan.sh --fail "$f" >/dev/null 2>&1; then
    :
  else
    code=$?
    if [[ "$code" -eq 2 ]]; then
      echo "[match] $f"
      ./tools/redflag-scan.sh "$f" || true
      found=1
    else
      echo "[warn] scanner error on $f"
      found=1
    fi
  fi
done < <(git ls-files \
  | grep -E '\.(md|txt|sh|yml|yaml|json)$' \
  | grep -vE '^examples/fixtures/' \
  | grep -vE '^tools/patterns/' \
  | grep -vE '^tools/run-checks\.sh$' || true)

if [[ "$found" -eq 1 ]]; then
  echo "[error] red flags detected"
  exit 1
fi
echo "[3/4] testing sanitize-neofetch pipeline"
printf "Host: demo-host\nKernel: 6.8.1-demo\nMemory: 4GiB / 16GiB\n" \
  | ./tools/sanitize-neofetch.sh --strict >/dev/null

echo "[4/4] testing safe-share workflow"
printf "Example value one\nExample value two\n" \
  | ./tools/safe-share.sh sanitize \
  | ./tools/safe-share.sh scan >/dev/null

echo "[ok] all local checks passed"
