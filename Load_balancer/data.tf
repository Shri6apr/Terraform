# Existing Resource Group
data "azurerm_resource_group" "rg" {
  name = "rg-storage-acc"
}

# Existing Virtual Network
data "azurerm_virtual_network" "vnet" {
  name                = "bastion-demo-vnet"
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Existing Web Subnet
data "azurerm_subnet" "web" {
  name                 = "web-tier-subnet"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

# Existing App Subnet
data "azurerm_subnet" "app" {
  name                 = "app-tier-subnet"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

# Existing DB Subnet
data "azurerm_subnet" "db" {
  name                 = "db-tier-subnet"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}