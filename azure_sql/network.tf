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

# Create the subnets
resource "azurerm_subnet" "internal" {
  name                 = "${var.prefix}-internal"
  resource_group_name  = azurerm_resource_group.dev-rg.name
  virtual_network_name = azurerm_virtual_network.devnet.name
  address_prefixes     = ["10.0.0.0/24"]
  service_endpoints    = ["Microsoft.Sql"]                    # Allowing subnet to reach managed SQL service
}

resource "azurerm_subnet" "data" {
  name                 = "${var.prefix}-data"
  resource_group_name  = azurerm_resource_group.dev-rg.name
  virtual_network_name = azurerm_virtual_network.devnet.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Sql"]

}

# Create network security group
resource "azurerm_network_security_group" "sshweb-allow" {
  name                = "${var.prefix}-sshweb-allow"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev-rg.name

  tags = {
    environment = var.tags["dev"]
  }
}




# Create Security rule for ssh
resource "azurerm_network_security_rule" "ssh-allow" {
  name                        = "${var.prefix}-ssh-allow"
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
  name                        = "${var.prefix}-web-allow"
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
