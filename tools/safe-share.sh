#!/usr/bin/env bash
set -euo pipefail

cmd="${1:-}"
shift || true

case "$cmd" in
  sanitize)
    # lê de stdin e imprime sanitizado
    ./tools/sanitize-neofetch.sh --strict
    ;;

  scan)
    # escaneia arquivo ou stdin
    ./tools/redflag-scan.sh "$@"
    ;;

  report)
    # gera relatório sanitizado a partir do neofetch
    out="${1:-sanitized-output.txt}"
    neofetch | ./tools/sanitize-neofetch.sh --strict > "$out"
    echo "[ok] wrote: $out"
    echo "[tip] scan: ./tools/redflag-scan.sh $out"
    ;;

  *)
    echo "Usage:"
    echo "  ./tools/safe-share.sh sanitize   < input.txt > out.txt"
    echo "  ./tools/safe-share.sh scan [file]"
    echo "  ./tools/safe-share.sh report [output-file]"
    exit 1
    ;;
esac
