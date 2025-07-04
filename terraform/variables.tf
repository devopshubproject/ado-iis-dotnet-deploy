### Variable definitions for the ADO IIS .NET Deploy Terraform module ###

variable "location" {
  default = "North Europe"
}

variable "resource_group_name" {
  description = "The name of the resource group where the resources will be created."
  type        = string
  default     = "iis-rg"
}

variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
  default     = "iis-vnet"
}

variable "vnet_address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "sub_name" {
  description = "The name of the subnet."
  type        = string
  default     = "iis-subnet"
}

variable "sub_address_space" {
  description = "The address space for the subnet."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "bastion_sub_name" {
  description = "The name of the subnet for the Bastion Host."
  type        = string
  default     = "bastion-subnet"
}

variable "bastion_sub_address_space" {
  description = "The address space for the Bastion Host subnet."
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "nsg_name" {
  description = "The name of the Network Security Group."
  type        = string
  default     = "iis-nsg"
}

variable "pip_name" {
  description = "The name of the Public IP for the Bastion Host."
  type        = string
  default     = "pip-bastion"
}

variable "allocation_method" {
  description = "The allocation method for the Public IP."
  type        = string
  default     = "Static"

}

variable "pip_sku" {
  description = "The SKU for the Public IP."
  type        = string
  default     = "Standard"
}

variable "nic_name" {
  description = "The name of the Network Interface Card."
  type        = string
  default     = "iis-nic"
}

variable "nic_ip_configuration_name" {
  description = "The name of the IP configuration for the Network Interface Card."
  type        = string
  default     = "internal"
}

variable "nic_pvt_ip_allocation" {
  description = "The private IP allocation method for the Network Interface Card."
  type        = string
  default     = "Dynamic"
}

variable "vm_name" {
  description = "The name of the Virtual Machine."
  type        = string
  default     = "iis-vm"
}

variable "vm_size" {
  description = "The size of the Virtual Machine."
  type        = string
  default     = "Standard_DS2_v2"
}

variable "vm_admin_username" {
  description = "The administrator username for the Virtual Machine."
  type        = string
  default     = "iisadmin"
}

variable "vm_admin_password" {
  description = "The administrator password for the Virtual Machine."
  type        = string
  default     = "P@ssw0rd1234!"
}

variable "provision_vm_agent" {
  description = "Whether to provision the VM agent."
  type        = bool
  default     = true
}

variable "enable_automatic_updates" {
  description = "Whether to enable automatic updates on the VM."
  type        = bool
  default     = true
}

variable "os_disk_caching" {
  description = "The caching type for the OS disk."
  type        = string
  default     = "ReadWrite"
}

variable "os_disk_storage_account_type" {
  description = "The storage account type for the OS disk."
  type        = string
  default     = "Standard_LRS"
}

variable "sql_server_name" {
  description = "Name of the SQL Server"
  type        = string
  default     = "iis-sql-server"
}

variable "sql_admin_username" {
  description = "Administrator username for SQL Server"
  type        = string
  default     = "sqladmin"
}

variable "sql_admin_password" {
  description = "Administrator password for SQL Server"
  type        = string
  sensitive   = true
  default     = "P@ssw0rd123!"
}

variable "database_name" {
  description = "Name of the SQL Database"
  type        = string
  default     = "iisdb"
}

variable "database_max_size_gb" {
  description = "Maximum size of the database in GB"
  type        = number
  default     = 10
}

variable "database_sku_name" {
  description = "SKU name for the database"
  type        = string
  default     = "S0"
}
variable "my_ip_address" {
  description = "Your IP address for firewall rule"
  type        = string
  default     = "0.0.0.0"
}