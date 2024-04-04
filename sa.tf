resource "azurerm_storage_account" "move2cloud" {
  name                     = "move2cloudstorage"
  resource_group_name      = azurerm_resource_group.move2cloud.name
  location                 = azurerm_resource_group.move2cloud.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

