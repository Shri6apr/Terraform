resource "azurerm_linux_virtual_machine_scale_set" "web" {
  name = "${var.prefix}-web-vmss"
  resource_group_name = data.azurerm_resource_group.rg.name
  location = data.azurerm_resource_group.rg.location
  sku = var.vm_size
  instances = var.instance_count
  admin_username = var.admin_username
  disable_password_authentication = true
  upgrade_mode = "Manual"
  admin_ssh_key {
    username = var.admin_username
    public_key = file(pathexpand(var.ssh_public_key_path))
  }
  source_image_reference {
    publisher = "Canonical"
    offer = "0001-com-ubuntu-server-jammy"
    sku = "22_04-lts-gen2"
    version = "latest"
  }
  os_disk {
    storage_account_type = "Standard_LRS"
    caching = "ReadWrite"
  }
  network_interface {
    name = "web-nic"
    primary = true
    ip_configuration {
      name = "internal"
      primary = true
      subnet_id = data.azurerm_subnet.web.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.web.id]
    }
  }
  custom_data = base64encode(<<-SCRIPT
#!/bin/bash
set -eux
apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y nginx
printf '<h1>Hello from %s</h1>\n' "$(hostname)" > /var/www/html/index.html
systemctl enable --now nginx
SCRIPT
  )
  tags = var.tags
  lifecycle { ignore_changes = [instances] }
}
