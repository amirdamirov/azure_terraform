resource "azurerm_log_analytics_workspace" "fwlogs" {
  name                = "logs-${random_pet.primary.id}"
  location            = azurerm_resource_group.k8srg.location
  resource_group_name = azurerm_resource_group.k8srg.name
  retention_in_days   = 30
}