#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   neofetch | ./tools/sanitize-neofetch.sh > sanitized.txt
#   cat raw.txt | ./tools/sanitize-neofetch.sh --strict > sanitized.txt
#
# Best-effort sanitizer. Always manually review before publishing.

STRICT=0
if [[ "${1:-}" == "--strict" ]]; then
  STRICT=1
fi

# Remove common shell prompts like:
#   user@host:~/path$ ...
#   [user@host ~]$ ...
sed -E \
  -e 's/^[^ ]+@[^ :]+:[^$#]*[$#] ?/(prompt removed) /' \
  -e 's/^\[[^@]+@[^ ]+ [^]]+\][$#] ?/(prompt removed) /' |
{
  if [[ "$STRICT" -eq 1 ]]; then
    # Strict mode: generalize more fields
    sed -E \
      -e 's/^[[:space:]]*Host: .*/Host: (redacted)/I' \
      -e 's/^[[:space:]]*Kernel: .*/Kernel: (generalized)/I' \
      -e 's/^[[:space:]]*Uptime: .*/Uptime: (generalized)/I' \
      -e 's/^[[:space:]]*Packages: .*/Packages: (generalized)/I' \
      -e 's/^[[:space:]]*Shell: .*/Shell: (generalized)/I' \
      -e 's/^[[:space:]]*Resolution: .*/Resolution: (generalized)/I' \
      -e 's/^[[:space:]]*Terminal: .*/Terminal: (generalized)/I' \
      -e 's/^[[:space:]]*Memory: .*/Memory: (generalized)/I'
  else
    # Normal mode: sanitize the most common high-risk fields
    sed -E \
      -e 's/^[[:space:]]*Host: .*/Host: (redacted)/I' \
      -e 's/^[[:space:]]*Kernel: .*/Kernel: 6.x (generalized)/I' \
      -e 's/^[[:space:]]*Shell: .*/Shell: (generalized)/I' \
      -e 's/^[[:space:]]*Memory: .*/Memory: (generalized)/I'
  fi
}
