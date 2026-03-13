#!/usr/bin/env bash
set -euo pipefail

ignore_file=".redflagignore"
fail_mode=0

should_ignore() {
  local file="$1"

  [[ "$file" == "-" ]] && return 1

  if [[ -f "$ignore_file" ]]; then
    while IFS= read -r pattern; do
      [[ -z "$pattern" ]] && continue
      [[ "$pattern" =~ ^# ]] && continue

      if [[ "$file" == "$pattern"* ]]; then
        return 0
      fi
    done < "$ignore_file"
  fi

  return 1
}

if [[ "${1:-}" == "--fail" ]]; then
  fail_mode=1
  shift
fi

scan_stream() {
  local source="$1"
  local matched=0

  echo "[redflag-scan] scanning: $source"

  # More specific patterns to reduce false positives.
  local patterns=(
    '192\.168\.[0-9]{1,3}\.[0-9]{1,3}'
    '/home/[A-Za-z0-9._-]+/'
    '/Users/[A-Za-z0-9._-]+/'
    '(api[_-]?key|token|secret)[[:space:]]*[:=][[:space:]]*[^[:space:]]{8,}'
  )

  local pattern
  for pattern in "${patterns[@]}"; do
    if grep -E -n "$pattern" ; then
      matched=1
    fi
  done

  if [[ "$matched" -eq 1 ]]; then
    if [[ "$fail_mode" -eq 1 ]]; then
      return 2
    fi
    return 0
  fi

  echo "[redflag-scan] no obvious sensitive patterns found"
  return 0
}

if [[ $# -eq 0 ]]; then
  if ! scan_stream "stdin"; then
    exit $?
  fi
  exit 0
fi

status=0

for file in "$@"; do
  if should_ignore "$file"; then
    continue
  fi

  if [[ ! -f "$file" ]]; then
    echo "[redflag-scan] warning: file not found: $file"
    status=1
    continue
  fi

  scan_stream "$file" < "$file"
  code=$?

  if [[ "$code" -eq 2 ]]; then
    status=2
  elif [[ "$code" -ne 0 ]]; then
    status=1
  fi
done

exit "$status"
