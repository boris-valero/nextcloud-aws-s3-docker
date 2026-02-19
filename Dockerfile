FROM nextcloud:31-apache

# Copier le script de pré-configuration S3
COPY config-s3.config.php /usr/src/nextcloud/config/s3.config.php

# Le script sera automatiquement chargé par Nextcloud au démarrage
