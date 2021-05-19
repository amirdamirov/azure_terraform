# terraform {
#  backend "azurerm" {
#    resource_group_name  = "myDEVResourceGroup"
#    storage_account_name = "tstate27592"
#    container_name       = "tstate"
#    key                  = "terraform.tfstate"     # azure blob name
#  }
#} 