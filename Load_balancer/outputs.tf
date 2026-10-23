output "website_url" { value = "http://${azurerm_public_ip.lb.ip_address}" }
output "lb_public_ip" { value = azurerm_public_ip.lb.ip_address }
output "web_private_ips" { value = { for k, nic in azurerm_network_interface.web : k => nic.private_ip_address } }
