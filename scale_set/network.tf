# Create a virtual network
resource "azurerm_virtual_network" "devnet" {
  name                = "devnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.dev-rg.name
  tags = {
    environment = var.tags["dev"]
  }
}

# Create a subnet
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.dev-rg.name
  virtual_network_name = azurerm_virtual_network.devnet.name
  address_prefixes     = ["10.0.1.0/24"]
}


# Create network security group
resource "azurerm_network_security_group" "sshweb-allow" {
  name                = "sshweb-allow"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev-rg.name

  tags = {
    environment = var.tags["dev"]
  }
}



# Create Security rule for ssh
resource "azurerm_network_security_rule" "ssh-allow" {
  name                        = "ssh-allow"
  priority                    = 100
  direction                   = "inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.dev-rg.name
  network_security_group_name = azurerm_network_security_group.sshweb-allow.name
}

# Create Security rule for web
resource "azurerm_network_security_rule" "web-allow" {
  name                        = "web-allow"
  priority                    = 101                               
  direction                   = "inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  destination_address_prefix  = "*"
  source_address_prefix       = "*"
  resource_group_name         = azurerm_resource_group.dev-rg.name
  network_security_group_name = azurerm_network_security_group.sshweb-allow.name
}

resource "azurerm_public_ip" "vmss-ip" {
 name                         = "vmss-ip"
 location                     = var.location
 resource_group_name          = azurerm_resource_group.dev-rg.name
 allocation_method = "Static"
 # domain_name_label            = random_string.fqdn.result
 tags = {
    environment = var.tags["dev"]
  }
}

