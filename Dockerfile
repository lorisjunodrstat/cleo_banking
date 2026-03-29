FROM python:3.11-slim

# Variables d'environnement pour Python
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /app

# Installation des dépendances système
# Ajout de 'build-essential' si gcc ne suffit pas pour certaines libs Python
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    default-libmysqlclient-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Installation des dépendances Python
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copie du projet
COPY . .

# Gestion des permissions (Bonne pratique : ne pas rester en Root)
RUN mkdir -p uploads && chmod 755 uploads

# Script d'entrée
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 5000

ENTRYPOINT ["/entrypoint.sh"]