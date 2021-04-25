# Create mysql server service

resource "azurerm_mysql_server" "dev-mysqlserver-1991" {
  name                = "${var.prefix}-mysqlserver-1991"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev-rg.name

  administrator_login          = "Cloudadmin"
  administrator_login_password = "H@Sh1CoR3!"

  sku_name   = "GP_Gen5_8"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false           # Enable it in prod envs
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

# Create MYSQL database

resource "azurerm_mysql_database" "devdb" {
  name                = "${var.prefix}db"
  resource_group_name = azurerm_resource_group.dev-rg.name
  server_name         = azurerm_mysql_server.dev-mysqlserver-1991.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

# Create network rule for this database. Allow certain subnets to be able to connect to this db. P.S YOU CANT USE THIS FEATURE WITH BASIC TEAR

resource "azurerm_mysql_virtual_network_rule" "internal-db-rule" {
  name                = "internal-db-rule"
  resource_group_name = azurerm_resource_group.dev-rg.name
  server_name         = azurerm_mysql_server.dev-mysqlserver-1991.name
  subnet_id           = azurerm_subnet.internal.id
}

resource "azurerm_mysql_virtual_network_rule" "data-db-rule" {
  name                = "data-db-rule"
  resource_group_name = azurerm_resource_group.dev-rg.name
  server_name         = azurerm_mysql_server.dev-mysqlserver-1991.name
  subnet_id           = azurerm_subnet.data.id
}