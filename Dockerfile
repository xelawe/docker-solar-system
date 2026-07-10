FROM python:3.11-slim

# Für Pillow benötigte System-Bibliotheken
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    libjpeg62-turbo-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Repository mit dem Solar-System-Skript klonen
RUN git clone --depth 1 https://github.com/xelawe/pi-solar-system.git /app

# Python-Abhängigkeit (nur Pillow wird zusätzlich zur Standardbibliothek benötigt)
RUN pip install --no-cache-dir Pillow

# Gepatchte main.py (unterstützt WIDTH/HEIGHT über Environment Variablen)
#COPY main.py /app/main.py
# ins original Rpo verlagert

# Kleine Startseite, die das generierte Bild anzeigt und alle paar Sekunden neu lädt
COPY index.html /app/index.html
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080

# Wie oft (in Sekunden) das Bild neu berechnet wird
ENV REFRESH_SECONDS=60
# Bildgröße in Pixeln
ENV WIDTH=600
ENV HEIGHT=600

ENTRYPOINT ["/entrypoint.sh"]
