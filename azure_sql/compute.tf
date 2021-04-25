# Create first VM
resource "azurerm_linux_virtual_machine" "dev-1" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.dev-rg.name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.dev-1.id
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("./id_rsa.pub")
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}


# NIC for first VM
resource "azurerm_network_interface" "dev-1" {
  name                = "dev-vm-nic-1"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev-rg.name

  ip_configuration {
    name                          = "dev-vm-1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
  }
}

resource "azurerm_public_ip" "myterraformpublicip" {
  name                = "myPublicIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev-rg.name
  allocation_method   = "Dynamic"

  tags = {
    environment = var.tags["dev"]
  }
}