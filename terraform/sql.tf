### SQL Server and Database Configuration

resource "azurerm_sql_server" "sql" {
  name                         = "sqlserversecureiis"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "SecureP@ssw0rd!123"

  identity {
    type = "SystemAssigned"
    }

resource "azurerm_sql_database" "sqldb" {
  name                = "iisappdb"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_sql_server.sql.location
  server_name         = azurerm_sql_server.sql.name
  sku_name            = "S0"
}

resource "azurerm_sql_firewall_rule" "allow_azure" {
  name                = "AllowAzureServices"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.sql.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}