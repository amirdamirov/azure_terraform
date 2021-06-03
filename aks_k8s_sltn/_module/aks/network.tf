resource "azurerm_virtual_network" "hubVnetAddress" {
  name                = "hubVnetAddress"
  location            = azurerm_resource_group.k8srg.location
  resource_group_name = azurerm_resource_group.k8srg.name
  address_space       = ["10.200.0.0/24"]

}

resource "azurerm_subnet" "AzureFirewallSubnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.k8srg.name
  virtual_network_name = azurerm_virtual_network.hubVnetAddress.name
  address_prefixes     = ["10.200.0.0/26"]
}
resource "azurerm_subnet" "gatewaysubnet" {
  name                 = "gatewaysubnet"
  resource_group_name  = azurerm_resource_group.k8srg.name
  virtual_network_name = azurerm_virtual_network.hubVnetAddress.name
  address_prefixes     = ["10.200.0.64/27"]
}
resource "azurerm_subnet" "bastionsubnet" {
  name                 = "bastionsubnet"
  resource_group_name  = azurerm_resource_group.k8srg.name
  virtual_network_name = azurerm_virtual_network.hubVnetAddress.name
  address_prefixes     = ["10.200.0.96/27"]
}

# resource "azurerm_network_security_group" "aks_sec_grp" {
#   name                = "aks_sec_grp"
#   location            = azurerm_resource_group.k8srg.location
#   resource_group_name = azurerm_resource_group.k8srg.name

#   dynamic security_rule {
#     for_each = ["80", "443", "22", "8080", "5701"]
#     content {
#       name                       = "aks_sec_grp_rules"
#       priority                   = 100
#       direction                  = "Inbound"
#       access                     = "Allow"
#       protocol                   = "Tcp"
#       source_port_range          = "*"
#       destination_port_range     = security_rule.value
#       source_address_prefix      = "*"
#       destination_address_prefix = "*"
#     }
#   }
# }

resource "azurerm_public_ip" "azure_fw_ip" {
  name                = "azure_fw_ip"
  resource_group_name = azurerm_resource_group.k8srg.name
  location            = azurerm_resource_group.k8srg.location
  allocation_method   = "Static"
  sku                 = "Standard"

}
resource "azurerm_firewall" "aks_frwl" {
  name                = "aks_frwl"
  location            = azurerm_resource_group.k8srg.location
  resource_group_name = azurerm_resource_group.k8srg.name
  zones               = [1, 2 ,3]

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.AzureFirewallSubnet.id
    public_ip_address_id = azurerm_public_ip.azure_fw_ip.id
  }
}

resource "azurerm_firewall_network_rule_collection" "aks_egress_dns" {
  name                = "aks_egress_dns"
  azure_firewall_name = azurerm_firewall.aks_frwl.name
  resource_group_name = azurerm_resource_group.k8srg.name
  priority            = 100
  action              = "Allow"

  rule {
    name = "aks_egress_dns"

    source_addresses = [
      "*",
    ]

    destination_ports = [
      "53",
    ]

    destination_addresses = [
      "8.8.8.8",
      "8.8.4.4",
    ]

    protocols = [
      "UDP",
    ]
  }
}

# resource "azurerm_firewall_network_rule_collection" "aks_egress_ntp" {
#   name                = "aks_egress_ntp"
#   azure_firewall_name = azurerm_firewall.aks_frwl.name
#   resource_group_name = azurerm_resource_group.k8srg.name
#   priority            = 101
#   action              = "Allow"

#   rule {
#     name = "aks_egress_ntp"

#     source_addresses = [
#       "*",
#     ]

#     destination_ports = [
#       "123",
#     ]

#     destination_fqdns = [
#       "ntp.ubuntu.com"
#     ]

#     protocols = [
#       "UDP",
#     ]
#   }
# }


resource "azurerm_firewall_application_rule_collection" "aks_ntp_rule" {
  name                = "aks_ntp_rule"
  azure_firewall_name = azurerm_firewall.aks_frwl.name
  resource_group_name = azurerm_resource_group.k8srg.name
  priority            = 102
  action              = "Allow"

  rule {
    name             = "allow network"
    source_addresses = ["*"]

    target_fqdns = [
       "ntp.ubuntu.com"
    ]

    protocol {
      port = "123"
      type = "Http"
    }
  }
}


resource "azurerm_firewall_application_rule_collection" "aks_app_rules" {
  name                = "aks_app_rules"
  azure_firewall_name = azurerm_firewall.aks_frwl.name
  resource_group_name = azurerm_resource_group.k8srg.name
  priority            = 103
  action              = "Allow"

  rule {
    name             = "allow network"
    source_addresses = ["*"]

    target_fqdns = [
      "*.cdn.mscr.io",
      "mcr.microsoft.com",
      "*.data.mcr.microsoft.com",
      "management.azure.com",
      "login.microsoftonline.com",
      "acs-mirror.azureedge.net",
      "dc.services.visualstudio.com",
      "*.opinsights.azure.com",
      "*.oms.opinsights.azure.com",
      "*.microsoftonline.com",
      "*.monitoring.azure.com",
      "packages.microsoft.com",
      "security.ubuntu.com",
      "azure.archive.ubuntu.com",
      "changelogs.ubuntu.com",
      "data.policy.core.windows.net",
      "store.policy.core.windows.net",
      "dc.services.visualstudio.com"
    ]

    protocol {
      port = "80"
      type = "Http"
    }

    protocol {
      port = "443"
      type = "Https"
    }
  }
}

resource "azurerm_firewall_network_rule_collection" "servicetags" {
  name                = "servicetags"
  azure_firewall_name = azurerm_firewall.aks_frwl.name
  resource_group_name = azurerm_resource_group.k8srg.name
  priority            = 110
  action              = "Allow"

  rule {
    description       = "allow service tags"
    name              = "allow service tags"
    source_addresses  = ["*"]
    destination_ports = ["*"]
    protocols         = ["Any"]

    destination_addresses = [
      "AzureContainerRegistry",
      "MicrosoftContainerRegistry",
      "AzureActiveDirectory",
      "AzureMonitor"
    ]
  }
}

resource "azurerm_route_table" "fw_aks" {
  name                          = "fw_aks"
  location            = azurerm_resource_group.k8srg.location
  resource_group_name = azurerm_resource_group.k8srg.name
  disable_bgp_route_propagation = false

  route {
    name           = "fw_aks"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.aks_frwl.ip_configuration.0.private_ip_address
  }
  
  depends_on = [azurerm_firewall.aks_frwl]

    # AKS may add routes Terraform is not aware of (e.g. kubelet networking mode)
  lifecycle {
    ignore_changes             = [route]
  }  

}


resource "azurerm_virtual_network" "spokeVnetAddress" {
  name                = "spokeVnetAddress"
  location            = azurerm_resource_group.k8srg.location
  resource_group_name = azurerm_resource_group.k8srg.name
  address_space       = ["10.240.0.0/16"]

}

resource "azurerm_subnet" "akssubnet" {
  name                 = "akssubnet"
  resource_group_name  = azurerm_resource_group.k8srg.name
  virtual_network_name = azurerm_virtual_network.spokeVnetAddress.name
  address_prefixes     = ["10.240.0.0/22"]
}

resource "azurerm_subnet" "akslbsubnet" {
  name                 = "akslbsubnet"
  resource_group_name  = azurerm_resource_group.k8srg.name
  virtual_network_name = azurerm_virtual_network.spokeVnetAddress.name
  address_prefixes     = ["10.240.4.0/28"]
}

resource "azurerm_virtual_network_peering" "hubVnet" {
  name                      = "peerhubtospoke"
  resource_group_name       = azurerm_resource_group.k8srg.name
  virtual_network_name      = azurerm_virtual_network.hubVnetAddress.name
  remote_virtual_network_id = azurerm_virtual_network.spokeVnetAddress.id
}

resource "azurerm_virtual_network_peering" "spokeVnet" {
  name                      = "peerspoketohub"
  resource_group_name       = azurerm_resource_group.k8srg.name
  virtual_network_name      = azurerm_virtual_network.spokeVnetAddress.name
  remote_virtual_network_id = azurerm_virtual_network.hubVnetAddress.id
}
