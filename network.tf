# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "myDEVVnet"
    address_space       = ["10.0.0.0/16"]
    location            = var.location     
    resource_group_name = azurerm_resource_group.dev-rg.name
    tags = {
      environment = var.tags["dev"]
    }
}

resource "azurerm_subnet" "web" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.dev-rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "ssh-allow" {
  name                = "ssh-allow"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev-rg.name

  tags = {
    environment = var.tags["dev"]
  }
}

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
  network_security_group_name = azurerm_network_security_group.ssh-allow.name
}


resource "azurerm_public_ip" "myterraformpublicip" {
    name                         = "myPublicIP"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.dev-rg.name
    allocation_method            = "Dynamic"

    tags = {
        environment = var.tags["dev"]
    }
}


resource "azurerm_network_interface" "main" {
  name                = "dev-vm-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev-rg.name

  ip_configuration {
    name                          = "dev-vm-1"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
  }
}

resource "azurerm_network_interface_security_group_association" "ssh-association" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.ssh-allow.id
}