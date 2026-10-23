resource "azurerm_public_ip" "lb" {
  name = "${var.prefix}-lb-pip"
  location = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method = "Static"
  sku = "Standard"
  tags = var.tags
}
resource "azurerm_lb" "web" {
  name = "${var.prefix}-lb"
  location = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku = "Standard"
  frontend_ip_configuration {
    name = "public-frontend"
    public_ip_address_id = azurerm_public_ip.lb.id
  }
  tags = var.tags
}
resource "azurerm_lb_backend_address_pool" "web" {
  name = "web-backend"
  loadbalancer_id = azurerm_lb.web.id
}
resource "azurerm_lb_probe" "http" {
  name = "http-health"
  loadbalancer_id = azurerm_lb.web.id
  protocol = "Tcp"
  port = 80
}
resource "azurerm_lb_rule" "http" {
  name = "http-rule"
  loadbalancer_id = azurerm_lb.web.id
  protocol = "Tcp"
  frontend_port = 80
  backend_port = 80
  frontend_ip_configuration_name = "public-frontend"
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.web.id]
  probe_id = azurerm_lb_probe.http.id
  disable_outbound_snat = true
}
