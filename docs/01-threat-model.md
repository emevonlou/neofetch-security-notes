#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   neofetch --stdout | ./tools/sanitize-neofetch.sh > sanitized.txt
#
# Note: This is a best-effort sanitizer. Always manually review output.

sed -E \
  -e 's/^Host: .*/Host: (redacted)/' \
  -e 's/^Kernel: [0-9]+\.[0-9]+\.[0-9]+[^ ]*/Kernel: 6.x/' \
  -e 's/^Uptime: .*/Uptime: (generalized)/' \
  -e 's/^Packages: .*/Packages: (generalized)/' \
  -e 's/^Shell: .*/Shell: (generalized)/' \
  -e 's/^Memory: [0-9.]+[A-Za-z]+ \/ [0-9.]+[A-Za-z]+/Memory: (generalized)/'
EOF

chmod +x tools/sanitize-neofetch.sh
