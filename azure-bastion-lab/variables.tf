variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "prefix" {
  description = "Name prefix for all resources"
  type        = string
  default     = "bastion-demo"
}

variable "admin_username" {
  description = "Admin username for the Linux VMs"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to your SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "admin_source_cidr" {
  description = "Your public IP in CIDR form (e.g. 203.0.113.10/32). Allowed to SSH to the bastion host VM on port 22."
  type        = string
}

variable "vm_size" {
  description = "VM size for both VMs"
  type        = string
  default     = "Standard_B2s"
}

variable "tags" {
  type    = map(string)
  default = { project = "bastion-demo" }
}
