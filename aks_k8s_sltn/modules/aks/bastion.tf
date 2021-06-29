# resource "azurerm_linux_virtual_machine" "bastion" {
#   name                = "bastion"
#   resource_group_name = azurerm_resource_group.k8srg.name
#   location            = azurerm_resource_group.k8srg.location
#   size                = "Standard_F2"
#   admin_username      = "azure"
#   admin_password      = "Tryhardbitch135?"    
#   network_interface_ids = [
#     azurerm_network_interface.bastion.id,
#   ]

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "16.04-LTS"
#     version   = "latest"
#   }
# }

# resource "azurerm_network_interface" "bastion" {
#   name                = "bastion"
#   location            = azurerm_resource_group.k8srg.location
#   resource_group_name = azurerm_resource_group.k8srg.name

#   ip_configuration {
#     name                          = "dev-vm-1"
#     subnet_id                     = azurerm_subnet.bastionsubnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
#   }
# }

# resource "azurerm_network_security_group" "ssh-allow" {
#   name                = "ssh-allow"
#   location            = azurerm_resource_group.k8srg.location
#   resource_group_name = azurerm_resource_group.k8srg.name

# }


# resource "azurerm_public_ip" "myterraformpublicip" {
#   name                = "myPublicIP"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.k8srg.name
#   allocation_method   = "Dynamic"

# }