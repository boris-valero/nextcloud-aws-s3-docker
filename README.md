# Nextcloud AWS S3 Docker - Cloud Infrastructure Project

## Présentation

Ce projet présente une architecture cloud complète avec containerization,
orchestration et object storage. Dans ce projet, l'architecture est composée de
: 

- **Containerization** : Déploiement d'applications via Docker, chaque service
  s'exécutant avec son conteneur sécurisé
- **Infrastructure-as-Code (IaC)** : Configuration entièrement codifiée avec
  Docker Compose
- **Cloud Object Storage** : Intégration d'AWS S3 pour le stockage scalable
- **Secrets Management** : Variables d'environnement pour protéger les credentials

## Stacks utilisées


|Service        |Technologie        |Rôle                                     |
|---------------|-------------------|-----------------------------------------|
|Application    |Nextcloud 31 Apache|Plateforme de collaboration cloud        |
|Base de données|PostgreSQL 16      |Stockage de la base de données           |
|Object Storage |LocalStack (AWS S3)|Simulation d'Amazon S3                   |
|Orchestration  |Docker Compose     |Orchestration multi-conteneur            |

## Déploiement

### Prérequis

- Docker Compose

### Étapes

#### 1️⃣ Cloner ou créer le projet

```bash
mkdir nextcloud-localstack-project
cd nextcloud-localstack-project
```
#### 2️⃣ Cloner le repository

```bash
git clone https://github.com/boris-valero/nextcloud-aws-s3-docker.git
```
#### 3️⃣ Lancer les services

```bash
cd nextcloud-aws-s3-docker
cp .env.example .env (fichier .env.example fourni uniquement dans l'optique de la démonstration du projet)
docker-compose up -d
```
#### 4️⃣ Rendre le script exécutable et exécuter le script

```bash
cd scripts
chmod +x scripts/init_s3.sh
./init_s3.sh
```
#### 5️⃣ Configurer Nextcloud

1.  Accéder à http://localhost:8082
2.  Créer un compte administrateur avec, par exemple :
- Utilisateur : `admin` (ou celui de votre choix)
- Mot de passe : `admin` (ou celui de votre choix)
3.  Aller dans le menu de Nextcloud > Applications
4.  Allez dans les applications désactivées, et activer l'application "External
    storage support"
5.  Aller dans le menu de Nextcloud > Paramètres d'administration > Stockages
    externes
6.  Ajouter un stockage Amazon S3 avec :
- Hostname : `localstack`
- Port : `4566`
- Bucket : `nextcloud-bucket`
- Region : `us-east-1`
- Access Key / Secret Key : `nextcloud-aws-s3` / `nextcloud-aws-s3`
- **Enable SSL** : décoché
- **Enable Path Style** : coché

#### 6️⃣ Tester

1.  Uploader un fichier dans le dossier S3 de Nextcloud
2.  Vérifier dans un terminal que le fichier se soit bien chargé :

```bash
docker exec -it localstack awslocal s3 ls s3://nextcloud-bucket/ --recursive
```

## Captures d'écran

### Interface Nextcloud avec dossier S3

![image](screenshots/nextcloud-s3-folder.png)

### Configuration du stockage externe

![image](screenshots/s3-configuration.png)

### Vérification dans LocalStack

![image](screenshots/terminal-bucket-list.png)

