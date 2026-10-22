#Vnet + Subnet 

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  address_space       = [local.vnet_cidr]
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = var.tags
}
#Bastian host =Jump server
resource "azurerm_subnet" "bastion_host" {
  name                 = "bastion-host-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [local.bastion_host_subnet]
}

# The name "AzureBastionSubnet" is mandatory for the Bastion service
resource "azurerm_subnet" "bastion_service" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [local.bastion_svc_subnet]
}

resource "azurerm_subnet" "web" {
  name                 = "web-tier-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [local.web_subnet]
}

resource "azurerm_subnet" "app" {
  name                 = "app-tier-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [local.app_subnet]
}

resource "azurerm_subnet" "db" {
  name                 = "db-tier-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [local.db_subnet]
}
