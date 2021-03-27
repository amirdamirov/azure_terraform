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

# Create a subnet
resource "azurerm_subnet" "web" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.dev-rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create application security group
resource "azurerm_application_security_group" "web-vm-1" {
  name                = "web-appsecuritygroup"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev-rg.name

  tags = {
    environment = var.tags["dev"]
  }
}

# Create app sec group association. It means which VM you need to add to this group. There you associate it with NICs of VM.
resource "azurerm_network_interface_application_security_group_association" "web-vm-ass" {
  network_interface_id          = azurerm_network_interface.dev-2.id
  application_security_group_id = azurerm_application_security_group.web-vm-1.id
}

# Create network security group
resource "azurerm_network_security_group" "ssh-allow" {
  name                = "ssh-allow"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev-rg.name

  tags = {
    environment = var.tags["dev"]
  }
}



# Create Security rule for ssh
resource "azurerm_network_security_rule" "inbound-allow" {
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

# Create Security rule for web
resource "azurerm_network_security_rule" "web-vm" {
  name                        = "web-allow"
  priority                    = 101                               # IF YOU USE "source_application_security_group_ids" THEN DELETE "source_address_prefix"
  direction                   = "inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  destination_address_prefix  = "*"
  source_application_security_group_ids = [azurerm_application_security_group.web-vm-1.id]
  resource_group_name         = azurerm_resource_group.dev-rg.name
  network_security_group_name = azurerm_network_security_group.ssh-allow.name
}


# Public IP for the first VM
resource "azurerm_public_ip" "myterraformpublicip" {
  name                = "myPublicIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev-rg.name
  allocation_method   = "Dynamic"

  tags = {
    environment = var.tags["dev"]
  }
}

# NIC for first VM
resource "azurerm_network_interface" "dev-1" {
  name                = "dev-vm-nic-1"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev-rg.name

  ip_configuration {
    name                          = "dev-vm-1"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
  }
}

# NIC for second VM
resource "azurerm_network_interface" "dev-2" {
  name                = "dev-vm-nic-2"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev-rg.name

  ip_configuration {
    name                          = "dev-vm-2"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
  }
}

# NIC association for First VM
resource "azurerm_network_interface_security_group_association" "ssh-association" {
  network_interface_id      = azurerm_network_interface.dev-1.id
  network_security_group_id = azurerm_network_security_group.ssh-allow.id
}