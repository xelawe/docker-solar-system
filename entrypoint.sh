#!/bin/sh
set -e

cd /app

# Docker Environment Variablen als Kommandozeilen-Parameter an main.py weiterreichen.
# main.py selbst kennt WIDTH/HEIGHT nicht als Env-Var, sondern nur als CLI-Argumente
# (--width/--height), damit es auch außerhalb von Docker direkt aufrufbar bleibt.
WIDTH="${WIDTH:-134}"
HEIGHT="${HEIGHT:-134}"

# Hintergrund-Schleife: erzeugt/aktualisiert pisolar.png regelmäßig
(
  while true; do
    python3 main.py --width "$WIDTH" --height "$HEIGHT" || echo "main.py ist fehlgeschlagen, versuche es beim nächsten Durchlauf erneut" >&2
    sleep "${REFRESH_SECONDS:-60}"
  done
) &

# Webserver im Vordergrund, damit der Container am Leben bleibt
exec python3 -m http.server 8080 --directory /app
