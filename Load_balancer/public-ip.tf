resource "azurerm_public_ip" "lb" {
  name = "${var.prefix}-public-ip"
  resource_group_name = data.azurerm_resource_group.rg.name
  location = local.location
  allocation_method = "Static"
  sku = "Standard"
  tags = var.tags
}
