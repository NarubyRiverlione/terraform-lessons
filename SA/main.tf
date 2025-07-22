terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

resource "random_string" "suffix" {
  length  = 8
  lower   = true
  numeric = true
  upper   = false
  special = false
}

resource "azurerm_storage_account" "sa" {
  name                          = "tfsa${random_string.suffix.result}"
  resource_group_name           = data.terraform_remote_state.rg.outputs.rg_name
  location                      = data.terraform_remote_state.rg.outputs.rg_location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  access_tier                   = "Cool"
  public_network_access_enabled = true

  # network_rules {
  #   default_action = "Deny"
  #   ip_rules       = ["178.116.96.183"]
  # }

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
