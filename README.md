# TP 3 - Infrastructure As Code avec Terraform

## Description
Ce dépôt contient les fichiers Terraform nécessaires pour déployer une infrastructure sur Azure, répondant aux besoins du client Move2Cloud.

## Fonctionnalités du Projet
- Création d'un groupe de ressources (azurerm_resource_group)
- Création d'un compte de stockage (azurerm_storage_account)
- Déploiement d'une VM Linux Ubuntu 22 LTS (azurerm_linux_virtual_machine), accessible en SSH depuis son serveur Terraform, avec les ressources associées.

## Guide d'Installation

### Prérequis
- Terraform installé (version >= 0.14)
- Azure CLI installé et configuré avec un accès au compte Azure

### Installation de Terraform et Azure CLI
- [Installation de Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [Installation d'Azure CLI](https://docs.microsoft.com/fr-fr/cli/azure/install-azure-cli-linux?pivots=apt)

### Connexion à Azure
\```bash
az login
\```

### Récupération du Subscription ID

```bash
az account list --query "[].{name:name, subscriptionId:id}"
```

### Création d’un Service Principal

```bash
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<YourSubscriptionId>"
```
> Le résultat fournira les informations nécessaires pour configurer l'authentification avec Azure :

**    appId = ARM_CLIENT_ID.
    password = ARM_CLIENT_SECRET.
    tenant = ARM_TENANT_ID.**

### Configuration des variables d’environnement

```bash
export ARM_SUBSCRIPTION_ID=<SubscriptionId>
export ARM_CLIENT_ID=<appI>
export ARM_CLIENT_SECRET=<password>
export ARM_TENANT_ID=<tenant>
```

### Structure du Projet

Le projet est organisé comme suit :

   - **main.tf**: Contient la définition du groupe de ressources.
   - **sa.tf**: Contient la définition du compte de stockage.
   - **vm.tf**: Contient les ressources pour la VM, y compris la VM elle-même.

### Exécution du Projet

   - Clonez ce dépôt.
   - Configurez les variables d'environnement comme indiqué ci-dessus.
   - Exécutez les commandes Terraform suivantes :

```bash
terraform init
terraform plan
terraform apply
```
