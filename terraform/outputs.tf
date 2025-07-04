# Outputs for SQL Server and Database

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "sql_server_name" {
  description = "Name of the SQL Server"
  value       = azurerm_mssql_server.sql.name
}

output "sql_server_fqdn" {
  description = "Fully qualified domain name of the SQL Server"
  value       = azurerm_mssql_server.sql.fully_qualified_domain_name
}

output "database_name" {
  description = "Name of the SQL Database"
  value       = azurerm_mssql_database.db.name
}

output "database_id" {
  description = "ID of the SQL Database"
  value       = azurerm_mssql_database.db.id
}

output "connection_string" {
  description = "Connection string for the SQL Database"
  value       = "Server=tcp:${azurerm_mssql_server.sql.fully_qualified_domain_name},1433;Database=${azurerm_mssql_database.db.name};User ID=${var.sql_admin_username};Password=${var.sql_admin_password};Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  sensitive   = true
}

output "iis_server_ip" {
  description = "Public IP address of the IIS server"
  value       = azurerm_windows_virtual_machine.vm.public_ip_address
}