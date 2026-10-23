resource "azurerm_linux_virtual_machine" "web" {
   for_each = toset([
    "web-vm-1",
    "web-vm-2",
    "web-vm-3"
  ])

  name = each.value
  resource_group_name = data.azurerm_resource_group.rg.name
  location = local.location
  size = var.vm_size
  admin_username = var.admin_username
  disable_password_authentication = true
  network_interface_ids = [azurerm_network_interface.web[each.key].id]
  admin_ssh_key {
    username = var.admin_username
    public_key = file(pathexpand(var.ssh_public_key_path))
  }
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer = "ubuntu-24_04-lts"
    sku = "server"
    version = "latest"
  }
  #vm pe hi web server (nginx,Try apache http server and nodejs next)install karlo fir ispe apna static website host karlo
  custom_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y nginx

    echo "<h1>Hello from ${each.value}</h1>" > /var/www/html/index.html

    systemctl enable --now nginx
  EOF
  )
}
