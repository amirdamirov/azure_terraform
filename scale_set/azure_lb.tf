resource "azurerm_public_ip" "lbip" {
  name                = "lpip"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev-rg.name
  allocation_method   = "Static"
  sku                 = length(var.zones) == 0 ? "Basic" : "Standard" # If lenght of the zones is 0 selecet BASIC else STANDART
  domain_name_label   = azurerm_resource_group.dev-rg.name
}

resource "azurerm_lb" "lbstandart" {
  name                = "lbstandart"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev-rg.name
  sku                 = length(var.zones) == 0 ? "Basic" : "Standard" # If lenght of the zones is 0 selecet BASIC else STANDART

  frontend_ip_configuration {
    name                 = "lbpublicip"
    public_ip_address_id = azurerm_public_ip.lbip.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb-backend-pool" {
  loadbalancer_id =  azurerm_lb.lbstandart.id
  name            = "lb-backend-pool"
}


resource "azurerm_lb_rule" "webrule" {
  resource_group_name            = azurerm_resource_group.dev-rg.name
  loadbalancer_id                = azurerm_lb.lbstandart.id
  name                           = "webrule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "lbpublicip"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb-backend-pool.id
  probe_id                       = azurerm_lb_probe.healthcheckweb.id
}

resource "azurerm_lb_probe" "healthcheckweb" {
  resource_group_name = azurerm_resource_group.dev-rg.name
  loadbalancer_id     = azurerm_lb.lbstandart.id
  name                = "healthcheckweb"
  protocol            = "Http"  
  request_path        = "/"
  port                = 80
}