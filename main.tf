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
  name     = "dev-rg"
  location = "westus2"
  tags = {
    environment = var.tags["dev"]
  }
}