data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "terraform-learn-${var.environment}"
  location = "West Europe"
  tags = {
    environment = var.environment
    created_by  = var.created_by
  }
}

resource "azurerm_role_assignment" "sp_contributor" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "sp_storage_reader" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = data.azurerm_client_config.current.object_id
}
