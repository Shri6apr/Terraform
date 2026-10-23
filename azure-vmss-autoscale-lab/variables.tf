variable "subscription_id" { type = string }
variable "resource_group_name" {
	type    = string
	default = "rg-storage-acc"
}
variable "vnet_name" {
	type    = string
	default = "bastion-demo-vnet"
}
variable "web_subnet_name" {
	type    = string
	default = "web-tier-subnet"
}
variable "prefix" {
	type    = string
	default = "vmss-demo"
}
variable "vm_size" {
	type    = string
	default = "Standard_B2s"
}
variable "admin_username" {
	type    = string
	default = "azureuser"
}
variable "ssh_public_key_path" {
	type    = string
	default = "~/.ssh/id_ed25519.pub"
}
variable "instance_count" {
	type    = number
	default = 2
}
variable "tags" {
	type    = map(string)
	default = { environment = "lab", managed_by = "terraform" }
}
