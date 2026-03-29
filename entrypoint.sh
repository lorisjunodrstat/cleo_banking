#!/bin/bash
set -e

echo "🔄 Attente de la disponibilité de MySQL..."

# Attendre que MySQL soit prêt (avec timeout)
for i in {1..30}; do
    if python -c "import pymysql; pymysql.connect(host='${DB_HOST}', port=${DB_PORT:-3306}, user='${DB_USER}', password='${DB_PASSWORD}', database='${DB_NAME}')" 2>/dev/null; then
        echo "✅ MySQL est prêt !"
        break
    fi
    echo "⏳ Tentative $i/30..."
    sleep 2
done

# Optionnel : initialiser la BDD si vous avez un script de migration
# python -m flask db upgrade  # si vous utilisez Flask-Migrate

echo "🚀 Démarrage de l'application Flask..."
exec python -m flask run --host=0.0.0.0 --port=5000