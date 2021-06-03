resource "azurerm_kubernetes_cluster" "dev" {
  name                    = "dev"
  location                = azurerm_resource_group.k8srg.location
  resource_group_name     = azurerm_resource_group.k8srg.name
  dns_prefix              = "devaks"
  private_cluster_enabled = true
  
 



  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_D2_v2"
    availability_zones   = [1, 2, 3]
    enable_auto_scaling  = true
    max_count            = 3
    min_count            = 1
    vnet_subnet_id       = azurerm_subnet.akssubnet.id
  }

  identity {
    type                        = "UserAssigned"
    user_assigned_identity_id   = azurerm_user_assigned_identity.k8s.id
  }
  
  role_based_access_control {   # activate Kubernetes RBAC 
      enabled = true

      azure_active_directory {
        managed = true
        admin_group_object_ids = [azuread_group.aks_administrators.object_id]     # These group members will be AKS admins

      }
    }

  tags = {
    Environment = "Develop"
  }

  depends_on = [azurerm_subnet.akssubnet]

}

# resource "azurerm_kubernetes_cluster_node_pool" "mem" {
#  kubernetes_cluster_id = azurerm_kubernetes_cluster.dev.id
#  name                  = "mem"
#  node_count            = "1"
#  vm_size               = "standard_d11_v2"
# }
