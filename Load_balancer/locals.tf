locals {
  web_instances = toset(["1", "2", "3"])
  location = data.azurerm_resource_group.rg.location
}
