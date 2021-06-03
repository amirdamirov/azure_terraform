terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.59.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "1.4.0"
    }
  }
}

provider "azuread" {
  # Configuration options
}

provider "azurerm" {
  features {}
}

resource "random_pet" "primary" {}

resource "azurerm_resource_group" "k8srg" {
  name     = "k8srg"
  location = "northeurope"
}

# resource "azurerm_resource_group" "rg-enterprise-networking-hubs" {
#   name     = "rg-enterprise-networking-hubs"
#   location = "northeurope"
# }

# resource "azurerm_resource_group" "rg-enterprise-networking-spoke" {
#   name     = "rg-enterprise-networking-spoke"
#   location = "northeurope"
# }


resource "azuread_group" "aks_administrators" {
  display_name = "aks_administrators"

}


resource "azurerm_user_assigned_identity" "k8s" {
  resource_group_name = azurerm_resource_group.k8srg.name
  location            = azurerm_resource_group.k8srg.location

  name = "k8s"
}


resource "azurerm_role_assignment" "network" {
  scope                = azurerm_virtual_network.spokeVnetAddress.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.k8s.principal_id
}


# terraform {
#   required_providers {
#     azuread = {
#       source = "hashicorp/azuread"
#       version = "1.4.0"
#     }
#   }
# }

