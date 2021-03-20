#!/bin/bash
# https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage
# This script will create storage account for save terraform state file in remote storage

RESOURCE_GROUP_NAME=myDEVResourceGroup
STORAGE_ACCOUNT_NAME=tstate$RANDOM
CONTAINER_NAME=tstate

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location westus2

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY

echo "storage_account_name: $STORAGE_ACCOUNT_NAME"
echo "container_name: $CONTAINER_NAME"
echo "access_key: $ACCOUNT_KEY"

# Create KeyVault
az keyvault create --name "KeyVaultDev$RANDOM" --resource-group "myDEVResourceGroup" --location "westus2"

# Add a StorageKey to Key Vault
az keyvault secret set --vault-name "KeyVaultDev16965" --name "ACCESSKEY" --value "copyfromcreatedkey"

# Export StorageKey as variable from KeyVault
export ARM_ACCESS_KEY=$(az keyvault secret show --name ACCESSKEY --vault-name KeyVaultDev16965 --query value -o tsv)