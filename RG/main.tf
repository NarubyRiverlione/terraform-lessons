terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
    cloud {     
    organization = "naruby-riverlione-org" 
    workspaces { 
      name = "Zero-RG" 
    } 
  } 
}
# create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "terraform-learn"
  location = "West Europe"
  tags = {
    environment = var.environment
    created_by  = var.created_by
  }
}
# assign the Contributer role to the service principal
resource "azurerm_role_assignment" "sp_contributor" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}
# assign "Storage Blob Data Reader" to the service principal to check existing blobs
resource "azurerm_role_assignment" "sp_storage_reader" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = data.azurerm_client_config.current.object_id
}