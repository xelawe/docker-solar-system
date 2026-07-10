# Pi Solar System – im Container mit Web-Zugriff

Dieses Setup baut das Skript aus [xelawe/pi-solar-system](https://github.com/xelawe/pi-solar-system)
in einen Container. Da `main.py` das Bild nur einmalig erzeugt und dann beendet,
läuft im Hintergrund eine Schleife, die es alle `REFRESH_SECONDS` Sekunden neu
berechnet. Ein einfacher Python-Webserver liefert das Bild sowie eine kleine
HTML-Seite mit Auto-Refresh aus.

## Starten

Mit Docker Compose (empfohlen):

```bash
docker compose up --build -d
```

Oder direkt mit Docker:

```bash
docker build -t pi-solar-system .
docker run -d -p 8080:8080 -e REFRESH_SECONDS=60 --name pi-solar-system pi-solar-system
```

## Aufrufen

- Web-Seite mit automatisch aktualisierendem Bild: http://localhost:8080/
- Direktes Bild (PNG):                             http://localhost:8080/pisolar.png

## Konfiguration

`main.py` selbst kennt keine Environment Variablen, sondern nimmt Breite/Höhe
als Kommandozeilen-Parameter entgegen (`--width` / `--height`) – so lässt es
sich auch ohne Docker direkt ausführen:

```bash
python3 main.py                          # Default: 134x134
python3 main.py --width 240 --height 135 # eigene Größe
```

Im Container übernimmt `entrypoint.sh` das Übersetzen der Docker Environment
Variablen in diese CLI-Parameter:

- `REFRESH_SECONDS` (Standard: 60) – wie oft das Bild neu berechnet wird.
- `WIDTH` (Standard: 134) – wird als `--width` an main.py übergeben.
- `HEIGHT` (Standard: 134) – wird als `--height` an main.py übergeben.

Beispiel mit angepasster Größe im Container:

```bash
docker run -d -p 8080:8080 -e WIDTH=240 -e HEIGHT=135 --name pi-solar-system pi-solar-system
```

**Hinweis:** Die Datum-/Uhrzeit-Beschriftung ist im Originalskript auf feste
Pixelkoordinaten (z. B. `(132, 7)`) gerechnet, gedacht für das ursprüngliche
240×135-Pico-Display. Bei kleineren `WIDTH`-Werten kann dieser Text am rechten
Rand abgeschnitten werden. Der Planeten-Kreis selbst skaliert korrekt mit
`HEIGHT`.

## Logs ansehen

```bash
docker logs -f pi-solar-system
```

## Stoppen

```bash
docker compose down
```
