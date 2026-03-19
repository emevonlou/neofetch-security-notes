#!/usr/bin/env bash
set -euo pipefail

ignore_file=".redflagignore"
patterns_file="tools/patterns/redflags.regex"
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

if [[ ! -f "$patterns_file" ]]; then
  echo "[redflag-scan] missing patterns file: $patterns_file" >&2
  exit 1
fi

build_regex() {
  grep -vE '^[[:space:]]*#|^[[:space:]]*$' "$patterns_file" | paste -sd'|' -
}

scan_content() {
  local source="$1"
  local content="$2"
  local matched=0
  local matches

  local regex
  regex="$(build_regex)"

  matches="$(printf '%s' "$content" | grep -nE "$regex" || true)"

  if [[ "$json_mode" -eq 0 ]]; then
    echo "[redflag-scan] scanning: $source"
  fi

  if [[ -n "$matches" ]]; then
    matched=1
  fi

  if [[ "$json_mode" -eq 1 ]]; then
    printf '{\n'
    printf '  "source": "%s",\n' "$source"
    printf '  "matched": %s,\n' "$([[ "$matched" -eq 1 ]] && echo true || echo false)"
    printf '  "matches": [\n'

    local first=1
    local line
    while IFS= read -r line; do
      [[ -z "$line" ]] && continue
      if [[ "$first" -eq 0 ]]; then
        printf ',\n'
      fi
      first=0
      line="${line//\\/\\\\}"
      line="${line//\"/\\\"}"
      printf '    "%s"' "$line"
    done <<< "$matches"

    printf '\n  ]\n'
    printf '}\n'

    if [[ "$matched" -eq 1 && "$fail_mode" -eq 1 ]]; then
      return 2
    fi
    return 0
  fi

  if [[ "$matched" -eq 1 ]]; then
    printf '%s\n' "$matches"
    if [[ "$fail_mode" -eq 1 ]]; then
      return 2
    fi
    return 0
  fi

  echo "[redflag-scan] no obvious sensitive patterns found"
  return 0
}

if [[ $# -eq 0 ]]; then
  content="$(cat)"
  scan_content "stdin" "$content"
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

  content="$(cat "$file")"

  set +e
  scan_content "$file" "$content"
  code=$?
  set -e

  if [[ "$code" -eq 2 ]]; then
    status=2
  elif [[ "$code" -ne 0 ]]; then
    status=1
  fi
done

exit "$status"
