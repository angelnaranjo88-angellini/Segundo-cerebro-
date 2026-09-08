#!/usr/bin/env bash
# Genera el CV en PDF de una hoja a partir de cv/plantilla-cv.html.
#
#   ./cv/generar-pdf.sh "55 1446 2738" [salida.pdf]
#
# El teléfono se pasa como argumento y NO se guarda en el repo (regla 5 de CLAUDE.md:
# sin datos de contacto directo). Requiere un Chromium/Chrome headless.
set -euo pipefail

TELEFONO="${1:?Uso: $0 \"<telefono>\" [salida.pdf]}"
SALIDA="${2:-CV-Luis-Angel-Sanchez-Naranjo.pdf}"
BASE="$(cd "$(dirname "$0")" && pwd)"

CHROME="${CHROME:-}"
if [[ -z "$CHROME" ]]; then
  for c in /opt/pw-browsers/chromium chromium chromium-browser google-chrome; do
    if command -v "$c" >/dev/null 2>&1 || [[ -x "$c" ]]; then CHROME="$c"; break; fi
  done
fi
[[ -n "$CHROME" ]] || { echo "No encontré Chromium. Define CHROME=/ruta/al/chrome" >&2; exit 1; }

TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
sed "s/__TELEFONO__/${TELEFONO}/" "$BASE/plantilla-cv.html" > "$TMP/cv.html"

"$CHROME" --headless --disable-gpu --no-sandbox --no-pdf-header-footer \
  --print-to-pdf="$(cd "$(dirname "$SALIDA")" && pwd)/$(basename "$SALIDA")" \
  "file://$TMP/cv.html" 2>/dev/null

echo "Listo: $SALIDA"
