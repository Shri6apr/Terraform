output "website_url" { value = "http://${azurerm_public_ip.lb.ip_address}" }
output "vmss_name" { value = azurerm_linux_virtual_machine_scale_set.web.name }
output "web_subnet_id" { value = data.azurerm_subnet.web.id }
