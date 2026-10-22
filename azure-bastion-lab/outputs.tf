output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output "bastion_vm_public_ip" {
  description = "Public IP of the Linux jump box"
  value       = azurerm_public_ip.bastion_vm.ip_address
}

output "web_vm_private_ip" {
  description = "Private IP of the web VM"
  value       = azurerm_network_interface.web_vm.private_ip_address
}

output "azure_bastion_public_ip" {
  description = "Public IP of the managed Azure Bastion service"
  value       = azurerm_public_ip.bastion_service.ip_address
}