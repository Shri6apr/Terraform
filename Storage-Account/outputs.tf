output "resource_group_name" {
  description = "Created resource group name"
  value       = azurerm_resource_group.tf_rg.name
}

output "storage_account_name" {
  description = "Created storage account name"
  value       = azurerm_storage_account.tf_storage_account.name
}

output "storage_account_location" {
  description = "Storage account region"
  value       = azurerm_storage_account.tf_storage_account.location
}