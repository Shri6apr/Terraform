resource "azurerm_network_interface" "web" {
  for_each = local.web_instances
  name = "${var.prefix}-web-${each.key}-nic"
  location = local.location
  resource_group_name = data.azurerm_resource_group.rg.name
  ip_configuration {
    name = "primary"
    subnet_id = data.azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = var.tags
}
resource "azurerm_network_interface_backend_address_pool_association" "web" {
  for_each = local.web_instances
  network_interface_id = azurerm_network_interface.web[each.key].id
  ip_configuration_name = "primary"
  backend_address_pool_id = azurerm_lb_backend_address_pool.web.id
}
