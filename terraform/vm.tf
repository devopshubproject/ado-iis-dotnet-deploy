### VM Configuration for IIS Server

resource "azurerm_windows_virtual_machine" "vm" {
  name                     = var.vm_name
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  size                     = var.vm_size
  admin_username           = var.vm_admin_username
  admin_password           = var.vm_admin_password
  network_interface_ids    = [azurerm_network_interface.nic.id]
  provision_vm_agent       = var.provision_vm_agent
  enable_automatic_updates = var.enable_automatic_updates

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  tags = local.common_tags
}

resource "azurerm_virtual_machine_extension" "iis" {
  name                 = "IISInstall"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
{
  "commandToExecute": "powershell -Command \"Install-WindowsFeature -name Web-Server -IncludeManagementTools\""
}
SETTINGS
}
