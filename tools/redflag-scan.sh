#!/usr/bin/env bash
set -euo pipefail

ignore_file=".redflagignore"
fail_mode=0
json_mode=0

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

while [[ $# -gt 0 ]]; do
  case "$1" in
    --fail)
      fail_mode=1
      shift
      ;;
    --json)
      json_mode=1
      shift
      ;;
    *)
      break
      ;;
  esac
done

scan_stream() {
  local source="$1"
  local matched=0
  local matches=()

  # More specific patterns to reduce false positives.
  local patterns=(
    '192\.168\.[0-9]{1,3}\.[0-9]{1,3}'
    '/home/[A-Za-z0-9._-]+/'
    '/Users/[A-Za-z0-9._-]+/'
    '(api[_-]?key|token|secret)[[:space:]]*[:=][[:space:]]*[^[:space:]]{8,}'
  )

  if [[ "$json_mode" -eq 0 ]]; then
    echo "[redflag-scan] scanning: $source"
  fi

  local pattern
  local result

  for pattern in "${patterns[@]}"; do
    result="$(grep -E -n "$pattern" || true)"
    if [[ -n "$result" ]]; then
      matched=1
      matches+=("$result")
      if [[ "$json_mode" -eq 0 && "$fail_mode" -eq 0 ]]; then
        printf '%s\n' "$result"
      fi
    fi
  done

  if [[ "$json_mode" -eq 1 ]]; then
    printf '{\n'
    printf '  "source": "%s",\n' "$source"
    printf '  "matched": %s,\n' "$([[ "$matched" -eq 1 ]] && echo true || echo false)"
    printf '  "matches": [\n'

    local first=1
    local escaped
    local line
    for line in "${matches[@]}"; do
      while IFS= read -r escaped; do
        [[ -z "$escaped" ]] && continue
        if [[ "$first" -eq 0 ]]; then
          printf ',\n'
        fi
        first=0
        escaped="${escaped//\\/\\\\}"
        escaped="${escaped//\"/\\\"}"
        printf '    "%s"' "$escaped"
      done <<< "$line"
    done

    printf '\n  ]\n'
    printf '}\n'

    if [[ "$matched" -eq 1 && "$fail_mode" -eq 1 ]]; then
      return 2
    fi
    return 0
  fi

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
  scan_stream "stdin"
  exit $?
fi

status=0

for file in "$@"; do
  if should_ignore "$file"; then
    continue
  fi

  if [[ ! -f "$file" ]]; then
    if [[ "$json_mode" -eq 0 ]]; then
      echo "[redflag-scan] warning: file not found: $file"
    fi
    status=1
    continue
  fi

  set +e
  scan_stream "$file" < "$file"
  code=$?
  set -e

  if [[ "$code" -eq 2 ]]; then
    status=2
  elif [[ "$code" -ne 0 ]]; then
    status=1
  fi
done

exit "$status"
