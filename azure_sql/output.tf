output "mysql_fqdn" {
  value = azurerm_mysql_server.dev-mysqlserver-1991.fqdn
}

output "demo_instance_ip" {
  description = "The actual ip address allocated for the resource."
  value       = azurerm_network_interface.dev-1.private_ip_address
}

output "demo_instance_public_ip" {
  description = "The actual ip address allocated for the resource."
  value       = azurerm_public_ip.myterraformpublicip.ip_address
}