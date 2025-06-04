# cassiope_final

Projet de transformation d'une architecture Java traditionnelle en une architecture microservices conteneurisée avec Docker, et déployable sur un cluster Kubernetes provisionné automatiquement via Terraform sur Azure ou AWS. Le projet utilise également Apache Airflow pour l'orchestration des workflows.

## 📁 Structure du projet

- `airflow/` : DAGs et configurations pour l'orchestration des workflows de données.
- `azure_terraform/` : Scripts Terraform pour le provisionnement automatique d'un cluster Kubernetes sur Azure (1 master node + 1 worker node).
- `terraform-aws/` : Modules Terraform pour le déploiement automatique d'un cluster Kubernetes sur AWS (1 master node + 1 worker node).
- `codebase/` : Code source principal de l'application, refactorisée depuis une architecture Java monolithique vers des microservices Dockerisés.
- `README.md` : Ce fichier de documentation.

## 🛠️ Technologies utilisées

- **Java** : Langage principal pour le développement initial de l'application.
- **Docker** : Conteneurisation des microservices pour une exécution isolée et portable.
- **Kubernetes** : Orchestration des microservices sur un cluster.
- **Terraform** : Infrastructure as Code pour le déploiement automatisé des clusters Kubernetes sur Azure et AWS.
- **Apache Airflow** : Orchestration des workflows de données.
- **Python** : Utilisé pour les scripts Airflow et autres automatisations.
- **Shell** : Scripts d'automatisation et de déploiement.

## 🚀 Démarrage rapide

1. **Cloner le dépôt** :
   ```bash
   git clone https://github.com/khaldountaktak/cassiope_final.git
   cd cassiope_final
   ```

2. **Configurer les variables d'environnement** :
   - Pour Azure : définir les variables nécessaires dans `azure_terraform/variables.tf`.
   - Pour AWS : définir les variables dans `terraform-aws/variables.tf`.

3. **Déployer le cluster Kubernetes** :
   ```bash
   # Pour Azure
   cd azure_terraform
   terraform init
   terraform apply

   # Pour AWS
   cd terraform-aws
   terraform init
   terraform apply
   ```

4. **Lancer les services avec Airflow** :
   ```bash
   cd airflow
   docker-compose up -d
   ```
