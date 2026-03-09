#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hooks_dir="$repo_root/.git/hooks"
source_hook="$repo_root/hooks/pre-commit"
target_hook="$hooks_dir/pre-commit"

if [[ ! -d "$hooks_dir" ]]; then
  echo "[error] .git/hooks directory not found. Are you inside the repository?" >&2
  exit 1
fi

if [[ ! -f "$source_hook" ]]; then
  echo "[error] source hook not found: $source_hook" >&2
  exit 1
fi

ln -sf ../../hooks/pre-commit "$target_hook"
chmod +x "$source_hook"

echo "[ok] pre-commit hook installed"
echo "[info] target: $target_hook"
