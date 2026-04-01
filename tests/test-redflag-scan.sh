#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$ROOT_DIR/tools/redflag-scan.sh"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

pass() {
  printf 'PASS: %s\n' "$1"
}

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

assert_contains() {
  local output="$1"
  local expected="$2"
  local name="$3"

  if grep -Fq "$expected" <<< "$output"; then
    pass "$name"
  else
    printf 'Output was:\n%s\n' "$output" >&2
    fail "$name"
  fi
}

assert_exit_code() {
  local actual="$1"
  local expected="$2"
  local name="$3"

  if [[ "$actual" -eq "$expected" ]]; then
    pass "$name"
  else
    printf 'Expected exit code %s, got %s\n' "$expected" "$actual" >&2
    fail "$name"
  fi
}

run_test_detects_secret() {
  local file="$TMP_DIR/secret.txt"
  cat > "$file" <<'EOF'
api_key = "example_dummy_value"
EOF

  local output
  output="$("$SCRIPT" "$file")"

  assert_contains "$output" "[high]" "detects high severity secret"
  assert_contains "$output" "api_key" "reports matching content"
}

run_test_no_match() {
  local file="$TMP_DIR/clean.txt"
  cat > "$file" <<'EOF'
this is a harmless file
EOF

  local output
  output="$("$SCRIPT" "$file")"

  assert_contains "$output" "no sensitive patterns detected" "reports clean file"
}

run_test_fail_mode_exit_code() {
  local file="$TMP_DIR/fail.txt"
  cat > "$file" <<'EOF'
token: dummy_token_value
EOF

  local output
  local code

  set +e
  output="$("$SCRIPT" --fail "$file" 2>&1)"
  code=$?
  set -e

  assert_exit_code "$code" 2 "returns exit code 2 in fail mode when match is found"
  assert_contains "$output" "scanning:" "still announces scanned file in fail mode"
}

run_test_ignore_file() {
  local ignored_file="$TMP_DIR/ignored.txt"
  cat > "$ignored_file" <<'EOF'
secret: dummy_secret_value
EOF

  cat > "$ROOT_DIR/.redflagignore" <<EOF
$ignored_file
EOF

  local output
  output="$("$SCRIPT" "$ignored_file")"

  if [[ -z "$output" ]]; then
    pass "ignores file listed in .redflagignore"
  else
    printf 'Output was:\n%s\n' "$output" >&2
    fail "ignores file listed in .redflagignore"
  fi

  rm -f "$ROOT_DIR/.redflagignore"
}

run_test_detects_secret
run_test_no_match
run_test_fail_mode_exit_code
run_test_ignore_file

printf '\nAll redflag-scan tests passed.\n'
