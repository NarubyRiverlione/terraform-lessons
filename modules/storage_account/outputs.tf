output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.sa.name
}

output "container_name" {
  description = "Name of the storage container"
  value       = azurerm_storage_container.container.name
}
