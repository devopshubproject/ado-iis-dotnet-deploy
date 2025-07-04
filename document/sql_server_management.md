## 1. Azure SQL Database Management

### 1.1 Creating and Configuring an Azure SQL Database Using Terraform

Azure SQL Database is a fully managed platform-as-a-service (PaaS) database engine that handles most database management functions such as upgrading, patching, backups, and monitoring without user involvement.

**Terraform** can be used to provision Azure SQL resources in a repeatable and consistent manner.

#### Example Terraform Code to Provision Azure SQL Database:

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = "North Eurpoe"
}

resource "azurerm_sql_server" "sqlserver" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin
  administrator_login_password = var.sql_password
}

resource "azurerm_sql_database" "sqldb" {
  name                = var.sql_db_name
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.sqlserver.name
  sku_name            = "GP_Gen5_2"  # General Purpose, Gen5, 2 vCores
  max_size_gb         = 10
  zone_redundant      = false
}
```

---

### 1.2 Automated Backups on Azure SQL Database

Azure SQL Database automatically performs backups for all databases. The backup retention period depends on the service tier and configuration:

- **Point-in-time restore** backups are kept for 7 to 35 days (configurable).
- **Long-term retention (LTR)** backups can be configured for up to 10 years.

Terraform currently does not configure backup policies directly on Azure SQL Database because backups are managed automatically by the service. However, you can configure **long-term retention policies** for the database using the Azure CLI or REST API.

#### Setting Long-Term Retention using Azure CLI:

```bash
az sql db ltr-policy set \
  --resource-group rg-sql-example \
  --server sqlserverexample01 \
  --database exampledb \
  --weekly-retention P1M \
  --monthly-retention P12M \
  --yearly-retention P5Y \
  --week-of-year 5
```

---

### 1.3 Restoring From Backups

You can restore an Azure SQL database to any point in time within the retention period, or restore from long-term retention backups.

#### Restore a Database Using Azure CLI:

```bash
az sql db restore \
  --dest-name exampledb-restored \
  --name exampledb \
  --resource-group rg-sql-example \
  --server sqlserverexample01 \
  --time "2025-07-01T12:00:00Z"
```

The restored database will be created as a new database on the server.

---

### 1.4 Restoring Azure SQL Database Without Azure CLI Commands

#### Terraform Limitations

- Terraform's Azure Provider currently does not support an explicit resource or data source for restoring an Azure SQL Database.
- Terraform can create and manage SQL Servers and Databases, but restoring a database from a backup is not supported directly.

#### Liquibase Scope

- Liquibase is a database schema and data change management tool, not designed to perform backup or restore operations.
- Liquibase cannot perform database restores.

---

### Practical Alternatives Without Azure CLI

#### Option 1: Use ARM/Bicep Templates

- Azure Resource Manager (ARM) templates allow deploying/restoring an Azure SQL Database from a point-in-time restore.
- Terraform can deploy ARM templates using the `azurerm_template_deployment` resource.

#### Sample ARM snippet for point-in-time restore:

```json
{
  "type": "Microsoft.Sql/servers/databases",
  "apiVersion": "2021-02-01-preview",
  "name": "[concat(parameters('serverName'), '/', parameters('databaseName'))]",
  "location": "[parameters('location')]",
  "properties": {
    "createMode": "PointInTimeRestore",
    "sourceDatabaseId": "[parameters('sourceDatabaseId')]",
    "restorePointInTime": "[parameters('restorePointInTime')]"
  }
}
```

#### Terraform example to deploy this ARM template:

```hcl
resource "azurerm_template_deployment" "sql_restore" {
  name                = "sqlDatabaseRestore"
  resource_group_name = azurerm_resource_group.rg.name
  deployment_mode     = "Incremental"

  template_body = file("sql_database_restore_template.json")

  parameters = {
    serverName         = azurerm_sql_server.sqlserver.name
    databaseName       = "restored-db-name"
    location           = azurerm_resource_group.rg.location
    sourceDatabaseId   = "/subscriptions/xxxx/resourceGroups/rg-sql-example/providers/Microsoft.Sql/servers/sqlserverexample01/databases/exampledb"
    restorePointInTime = "2025-07-01T12:00:00Z"
  }
}
```

#### Option 2: Use PowerShell or Azure SDKs with Automation

- Use Azure PowerShell scripts or Azure SDKs to perform restores.
- These can be integrated with Azure Automation or DevOps pipelines as needed.

---

## 2. Query Performance Evaluation and Optimization

### 2.1 Evaluating SQL Query Performance

To evaluate the performance of a SQL query, consider:

- **Execution time**: How long the query takes to complete.
- **Resource consumption**: CPU, memory, and I/O usage.
- **Execution plan**: Details of how SQL Server executes the query.

#### Tools & Techniques:

- **SQL Server Management Studio (SSMS)**
  - Use "Include Actual Execution Plan" to see how the query is executed.
  - Use `SET STATISTICS TIME ON` and `SET STATISTICS IO ON` to get query execution time and I/O stats.
- **Query Store** (available in Azure SQL Database)
  - Tracks query performance over time and identifies regressions.
- **Azure SQL Intelligent Insights**
  - Automatically detects performance issues and provides recommendations.
- **Dynamic Management Views (DMVs)**
  - Query DMVs like `sys.dm_exec_query_stats` for recent query execution stats.

---

### 2.2 Techniques to Improve Query Performance

- **Indexing**
  - Add appropriate indexes (clustered, non-clustered) on frequently filtered/joined columns.
  - Consider filtered or covering indexes to optimize specific queries.
- **Query Optimization**
  - Rewrite inefficient queries to reduce complexity.
  - Avoid `SELECT *`; only select needed columns.
  - Use joins and subqueries judiciously.
- **Statistics Maintenance**
  - Ensure statistics are up-to-date for the query optimizer.
- **Partitioning**
  - Partition large tables to improve query performance by reducing scanned data.
- **Caching**
  - Use result caching where possible.
- **Resource Management**
  - Scale up SQL Database tier or increase DTUs/vCores for resource-intensive workloads.
- **Use Query Hints and Plan Guides**
  - Force specific query plans or join types when necessary.

---

### Summary Table for Query Performance Tools

| Tool / Technique           | Purpose                                      | Usage Example                              |
|---------------------------|----------------------------------------------|--------------------------------------------|
| Execution Plan             | Visualizes query steps and costly operations | Enable in SSMS or use `EXPLAIN` in T-SQL  |
| Query Store               | Tracks query performance history              | Enabled by default in Azure SQL Database   |
| SET STATISTICS TIME/IO    | Measures time and IO cost of query             | `SET STATISTICS TIME ON; SELECT ...`       |
| DMVs                      | Inspect runtime query statistics               | Query `sys.dm_exec_query_stats`             |
| Azure Intelligent Insights | Automated performance insights                 | Available via Azure portal                  |

---

## References

- [Terraform Azure SQL Database Resource](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sql_database)
- [Azure SQL Database Backups](https://learn.microsoft.com/en-us/azure/azure-sql/database/automated-backups-overview)
- [Restore an Azure SQL Database](https://learn.microsoft.com/en-us/azure/azure-sql/database/restore-overview)
- [Query Performance Tuning](https://learn.microsoft.com/en-us/sql/relational-databases/performance/performance-tuning)
