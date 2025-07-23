output "rg_name" {
  description = "Name of the resource group"
  value       = module.rg.rg_name
}

output "rg_location" {
  description = "Location of the resource group"
  value       = module.rg.rg_location
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = module.sa.storage_account_name
}

output "container_name" {
  description = "Name of the storage container"
  value       = module.sa.container_name
}
