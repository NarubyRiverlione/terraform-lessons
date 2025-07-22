output "storage_account_name" {
  value       = azurerm_storage_account.sa.name
  description = "The storage account name"
}

output "container_name" {
  value       = azurerm_storage_container.container.name
  description = "The storage container name"
}
