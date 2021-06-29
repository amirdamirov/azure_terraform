### Useful commands

# Get AKS cluster id
AKS_ID=$(az aks show \
    --resource-group aks \
    --name azure \
    --query id -o tsv)
# Get VNET subnet id

VNET_SUBNET_ID='az network vnet subnet show \
--resource-group rg-handsonaks \
--vnet-name vnet-handsonaks \
--name akssubnet --query id -o tsv'



# You will also need a managed identity that has permission to create resources
# in the subnet you just created. To create the managed identity and give it
# access to your subnet, use the following commands:
az identity create --name handsonaks-mi \
--resource-group rg-handsonaks
IDENTITY_CLIENTID='az identity show --name handsonaks-mi \
--resource-group rg-handsonaks \
--query clientId -o tsv'
Control plane network security | 323
az role assignment create --assignee $IDENTITY_CLIENTID \
--scope $VNET_SUBNET_ID --role Contributor
IDENTITY_ID='az identity show --name handsonaks-mi \
--resource-group rg-handsonaks \
--query id -o tsv'
