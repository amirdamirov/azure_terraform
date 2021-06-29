resource "azurerm_kubernetes_cluster" "dev" {
  name                    = var.env
  location                = azurerm_resource_group.k8srg.location
  resource_group_name     = azurerm_resource_group.k8srg.name
  dns_prefix              = "${var.env}aks"
  private_cluster_enabled = true
  #node_resource_group     = nodesdev
  
 



  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_D2_v2"
    availability_zones   = [1, 2, 3]
    vnet_subnet_id       = azurerm_subnet.akssubnet.id
  }

  network_profile {
    docker_bridge_cidr = "172.17.0.1/16"
    dns_service_ip     = "10.2.0.10"
    network_plugin     = "azure"
    outbound_type      = "userDefinedRouting"
    service_cidr       = "10.2.0.0/24"
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

  depends_on = [azurerm_subnet_route_table_association.akstofw]

}

# resource "azurerm_kubernetes_cluster_node_pool" "mem" {
#  kubernetes_cluster_id = azurerm_kubernetes_cluster.dev.id
#  name                  = "mem"
#  node_count            = "1"
#  vm_size               = "standard_d11_v2"
# }
