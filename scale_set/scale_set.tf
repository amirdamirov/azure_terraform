resource "azurerm_linux_virtual_machine_scale_set" "dev-vmss" {
  name                = "dev-vmss"
  resource_group_name = azurerm_resource_group.dev-rg.name
  location            = var.location
  sku                 = "Standard_B1s"
  instances           = 2
  admin_username      = "adminuser"
  zones               = var.zones  
 

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("id_rsa.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "example"
    primary = true
    network_security_group_id = azurerm_network_security_group.sshweb-allow.id

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.internal.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb-backend-pool.id]

    }
  }

  custom_data = base64encode("#!/bin/bash\n\napt-get update -y && apt-get upgrade -y && apt-get install -y nginx && echo \"Hello World from host\" $HOSTNAME \"!\" | sudo tee -a /var/www/html/index.html")
}