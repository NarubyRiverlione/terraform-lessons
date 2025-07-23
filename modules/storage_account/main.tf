resource "random_string" "suffix" {
  length  = 8
  lower   = true
  numeric = true
  upper   = false
  special = false
}

resource "azurerm_storage_account" "sa" {
  name                          = "tfsa${random_string.suffix.result}"
  resource_group_name           = var.resource_group_name
  location                      = var.resource_group_location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  access_tier                   = "Cool"
  public_network_access_enabled = true

  tags = {
    environment = var.environment
    created_by  = var.created_by
  }
}

resource "azurerm_storage_container" "container" {
  name                  = "tfcontainer"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"

  metadata = {
    environment = var.environment
    created_by  = var.created_by
  }
}
