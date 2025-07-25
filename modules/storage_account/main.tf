resource "random_string" "suffix" {
  length  = 8
  lower   = true
  numeric = true
  upper   = false
  special = false
}

resource "azurerm_storage_account" "sa" {
  name                          = "tflearnsa${var.environment}${random_string.suffix.result}"

  precondition {
    condition     = length(self.name) >= 3 && length(self.name) <= 24 && length(regex("^[a-z0-9]+$", self.name)) == 1
    error_message = "Storage account name must be 3–24 lowercase alphanumeric characters."
  }
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
  name                  = "tflearncontainer-${var.environment}"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"

  metadata = {
    environment = var.environment
    created_by  = var.created_by
  }
}
