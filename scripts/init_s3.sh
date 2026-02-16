#!/bin/bash

echo "Initialisation du bucket S3 dans LocalStack."

echo "Attente du démarrage de LocalStack : "
sleep 5

echo "Création du bucket 'nextcloud-bucket' : "
docker exec -it localstack awslocal s3 mb s3://nextcloud-bucket 2>/dev/null || echo "Bucket déjà existant"

echo "Buckets S3 disponibles :"
docker exec -it localstack awslocal s3 ls

echo "Initialisation terminée."
