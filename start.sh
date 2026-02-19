#!/bin/bash

set -e

echo "Démarrage de Nextcloud avec S3 comme stockage principal..."
echo ""

if [ ! -f .env ]; then
    echo "Fichier .env non trouvé. Création depuis .env.example..."
    cp .env.example .env
    echo "Fichier .env créé. Vous pouvez le modifier si nécessaire."
    echo ""
fi

echo "Démarrage des services Docker."
docker compose up -d

echo ""
echo "Attente du démarrage de LocalStack (5 secondes)."
sleep 5

echo "Création du bucket S3 dans LocalStack."
docker exec localstack awslocal s3 mb s3://nextcloud-bucket 2>/dev/null || echo "Bucket déjà existant"
echo "Bucket prêt"

echo ""
echo "Attente de l'installation de Nextcloud (peut prendre 1-2 minutes)."
echo "Nextcloud s'installe automatiquement en arrière-plan."

COUNTER=0
MAX_WAIT=120
until docker exec nextcloud-aws-s3-docker-nextcloud-1 grep -q "'installed' => true" /var/www/html/config/config.php 2>/dev/null; do
    if [ $COUNTER -ge $MAX_WAIT ]; then
        echo "Timeout : Nextcloud n'a pas terminé son installation"
        exit 1
    fi
    echo -n "."
    sleep 2
    COUNTER=$((COUNTER + 2))
done

echo ""
echo "Nextcloud installé"
echo ""

echo "S3 pré-configuré comme stockage de stockage principal."

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ Installation terminée !"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🌐 Connectez-vous sur votre instance Nextcloud : http://localhost:8082"
echo ""
echo "👤 Identifiants :"
echo "   - Utilisateur : ${NEXTCLOUD_ADMIN_USER:-admin}"
echo "   - Mot de passe : ${NEXTCLOUD_ADMIN_PASSWORD:-admin}"
echo ""
echo "📦 Stockage principal : S3 (LocalStack)"
echo "   - Bucket : nextcloud-bucket"
echo "   - Endpoint : http://localstack:4566"
echo ""
