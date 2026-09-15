variable "resource_group_name" {
  description = "Resource group for the VM and private networking."
  type        = string
  default     = "rg-capacity-planning-pwauswpdstd0006"
}

variable "location" {
  description = "Azure region for deployment."
  type        = string
  default     = "westus2"
}

variable "vm_name" {
  description = "Azure VM resource name."
  type        = string
  default     = "pwauswpdstd0006"
}

variable "computer_name" {
  description = "Linux hostname/computer name."
  type        = string
  default     = "pwauswpdstd0006"
}

variable "admin_username" {
  description = "Linux admin username."
  type        = string
}

variable "admin_ssh_public_key" {
  description = "SSH public key used to access the VM."
  type        = string
}

variable "allowed_ssh_source_cidr" {
  description = "VPN/private network CIDR allowed to reach SSH (22)."
  type        = string
}

variable "vnet_name" {
  description = "Virtual network name."
  type        = string
  default     = "vnet-capacity-planning-opt"
}

variable "subnet_name" {
  description = "Subnet name."
  type        = string
  default     = "snet-app"
}

variable "vnet_address_space" {
  description = "Address space for the VNet."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefixes" {
  description = "Subnet address prefixes."
  type        = list(string)
  default     = ["10.0.0.0/24"]
}

variable "vm_private_ip_address" {
  description = "Static private IP for the VM NIC."
  type        = string
  default     = "10.0.0.5"
}

variable "vm_size" {
  description = "Azure VM size."
  type        = string
  default     = "Standard_D2s_v3"
}

variable "os_disk_size_gb" {
  description = "OS disk size in GB."
  type        = number
  default     = 150
}

variable "image_sku" {
  description = "Marketplace image SKU for Red Hat Enterprise Linux 8."
  type        = string
  default     = "8-lvm"
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default = {
    application = "Capacity Planning and Optimization"
    owner       = "venkat-agents-lab"
    environment = "prod"
    purpose     = "vpn-only"
  }
}
