#tf_rg local name in terraform

resource "azurerm_resource_group" "tf_rg" {
  name = var.resource_group_name
  #name is the actual azure storage account name. 

  location = var.location

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}
#as storage account name should be unique across azure, we are using random string to make it unique
resource "random_string" "suffix" {
  length  = 10
  lower   = true
  upper   = false
  numeric = true
  special = false
}

#resource:The Terraform block type. It means, “Create or manage an instance of a resource.”

#"random_string""The resource type, provided by the Random provider. It generates a random string.

#"suffix":The local name you choose for this resource. It helps you reference it elsewhere in your Terraform configuration.
resource "azurerm_storage_account" "tf_storage_account" {
  name = "sttf${random_string.suffix.result}"
  #name is the actual azure storage account name. 
  resource_group_name = azurerm_resource_group.tf_rg.name
  location            = azurerm_resource_group.tf_rg.location

  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}