#!/usr/bin/env bash
# Genera el CV en PDF de una hoja a partir de cv/plantilla-cv.html.
#
#   ./cv/generar-pdf.sh "55 1446 2738" ~/foto.png [salida.pdf]
#
# El teléfono y la fotografía se pasan como argumentos y NO se guardan en el repo
# (regla 5 de CLAUDE.md: sin datos de contacto ni personales). Requiere Chromium/Chrome
# headless y Python 3.
set -euo pipefail

TELEFONO="${1:?Uso: $0 \"<telefono>\" <foto.png> [salida.pdf]}"
FOTO="${2:?Uso: $0 \"<telefono>\" <foto.png> [salida.pdf]}"
SALIDA="${3:-CV-Luis-Angel-Sanchez-Naranjo.pdf}"
BASE="$(cd "$(dirname "$0")" && pwd)"

[[ -f "$FOTO" ]] || { echo "No encuentro la foto: $FOTO" >&2; exit 1; }

CHROME="${CHROME:-}"
if [[ -z "$CHROME" ]]; then
  for c in /opt/pw-browsers/chromium chromium chromium-browser google-chrome; do
    if command -v "$c" >/dev/null 2>&1 || [[ -x "$c" ]]; then CHROME="$c"; break; fi
  done
fi
[[ -n "$CHROME" ]] || { echo "No encontré Chromium. Define CHROME=/ruta/al/chrome" >&2; exit 1; }

TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT

TELEFONO="$TELEFONO" FOTO="$FOTO" PLANTILLA="$BASE/plantilla-cv.html" DESTINO="$TMP/cv.html" \
python3 - <<'PY'
import base64, mimetypes, os, pathlib
foto = pathlib.Path(os.environ['FOTO'])
mime = mimetypes.guess_type(foto.name)[0] or 'image/png'
uri  = f"data:{mime};base64," + base64.b64encode(foto.read_bytes()).decode()
html = pathlib.Path(os.environ['PLANTILLA']).read_text()
html = html.replace('__FOTO__', uri).replace('__TELEFONO__', os.environ['TELEFONO'])
pathlib.Path(os.environ['DESTINO']).write_text(html)
PY

mkdir -p "$(dirname "$SALIDA")"
"$CHROME" --headless --disable-gpu --no-sandbox --no-pdf-header-footer \
  --print-to-pdf="$(cd "$(dirname "$SALIDA")" && pwd)/$(basename "$SALIDA")" \
  "file://$TMP/cv.html" 2>/dev/null

echo "Listo: $SALIDA"
