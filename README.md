# Nextcloud AWS S3 Docker - Cloud Infrastructure Project

## Présentation

Ce projet a pour but d'automatiser le déploiement d'une infrastructure
Nextcloud avec pour espace de stockage principal un stockage de type AWS S3. Ce
projet présente une architecture cloud complète avec containerization,
orchestration et object storage. Dans ce projet, l'architecture est composée de
:

- **Containerization** : Déploiement d'applications via Docker, chaque service
  s'exécutant avec son conteneur sécurisé
- **Infrastructure-as-Code (IaC)** : Configuration entièrement codifiée avec
  Docker Compose
- **Cloud Object Storage** : AWS S3 configuré comme stockage principal de
  Nextcloud
- **Secrets Management** : Variables d'environnement pour protéger les credentials
- **Automatisation** : Configuration S3 entièrement automatisée au démarrage

## Stacks utilisées


|Service        |Technologie        |Rôle                                           |
|---------------|-------------------|-----------------------------------------------|
|Application    |Nextcloud 31 Apache|Plateforme de collaboration cloud              |
|Base de données|PostgreSQL 16      |Stockage de la base de données                 |
|Object Storage |LocalStack (AWS S3)|Stockage principal des fichiers (simule AWS S3)|
|Orchestration  |Docker Compose     |Orchestration multi-conteneur                  |

## Déploiement

### Prérequis

- Docker Compose

### ⚠️ Important : Persistence des données

**LocalStack Community** (version gratuite) ne supporte plus la persistence fiable depuis la v2.0. 

**Conséquence** : Si vous arrêtez et redémarrez les conteneurs Docker, vous devez **obligatoirement relancer le déploiement avec le script start.sh** pour recréer le bucket S3 et réinitialiser l'infrastructure correctement.

Pour une persistence fiable en production, utilisez AWS S3 réel ou LocalStack Pro.

### Étapes

#### 1️⃣ Cloner ou créer le projet

```bash
mkdir nextcloud-localstack-project
cd nextcloud-localstack-project
```
#### 2️⃣ Cloner le repository

```bash
git clone https://github.com/boris-valero/nextcloud-aws-s3-docker.git
cd nextcloud-aws-s3-docker
```
#### 3️⃣ Configurer les credentials

```bash
cp .env.example .env
```
Vous pouvez modifiez le fichier `.env` avec vos propres valeurs :

- `POSTGRES_PASSWORD` : Mot de passe de la base de données PostgreSQL
- `AWS_CREDENTIALS` : Access Key AWS S3 (pour LocalStack, garder la valeur par
  défaut)
- `AWS_SECRET` : Secret Key AWS S3 (pour LocalStack, garder la valeur par défaut)
- `NEXTCLOUD_ADMIN_USER` : Nom d'utilisateur administrateur Nextcloud
- `NEXTCLOUD_ADMIN_PASSWORD` : Mot de passe administrateur Nextcloud

**Note** : Pour une utilisation en production avec AWS S3 réel, remplacez les
credentials AWS par vos vraies clés.

#### 4️⃣ Lancer le déploiement

```bash
chmod +x start.sh
./start.sh
```
**Note** : Le script start.sh automatise l'intégralité du déploiement de
l'infrastructure. Il vérifie d'abord la présence du fichier .env (le crée
depuis .env.example si absent), puis démarre tous les conteneurs Docker
(Nextcloud, PostgreSQL, LocalStack). Il attend ensuite le démarrage de
LocalStack et crée automatiquement le bucket S3 nextcloud-bucket. Le script
patiente jusqu'à ce que Nextcloud termine son auto-installation (1-2 minutes
maximum), qui configure automatiquement le compte administrateur et le stockage
principal S3. Une fois terminé, il affiche les informations de connexion (URL,
credentials, endpoint S3) pour accéder immédiatement à l'instance Nextcloud.

#### 5️⃣ Accéder à Nextcloud

Ouvrez votre navigateur à l'adresse : **http://localhost:8082**

Nextcloud sera accessible avec les credentials définis dans votre fichier `.env`.

**Important** : Le stockage S3 est déjà configuré automatiquement comme **
stockage principal**. Tous les fichiers uploadés seront stockés directement dans
le bucket S3.

#### 6️⃣ Tester

1.  Uploader un fichier à partir de l'application Fichiers
2.  Vérifier dans un terminal que le fichier se soit bien chargé grâce à la commande :

```bash
docker exec -it localstack awslocal s3 ls s3://nextcloud-bucket/ --recursive
```
## Captures d'écran

### Interface Nextcloud avec chargement d'une image "regles clean_code.jpeg"

![image](screenshots/nextcloud-s3-folder.png)

### Vérification dans LocalStack

![image](screenshots/terminal-bucket-list.png)

