# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}

# Create resource group
resource "azurerm_resource_group" "dev-rg" {
  name     = "myDEVResourceGroup"
  location = "westus2"
  tags = {
    "env" = "dev"
  }
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "myDEVVnet"
    address_space       = ["10.0.0.0/16"]
    location            = var.location     
    resource_group_name = azurerm_resource_group.dev-rg.name
    tags = {
      "env" = "dev"
    }
}

