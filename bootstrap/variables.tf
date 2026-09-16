variable "resource_group_name" {
  description = "Resource group name for Terraform state resources."
  type        = string
  default     = "tfstate-rg"
}

variable "location" {
  description = "Azure region for the Terraform state resources."
  type        = string
  default     = "westus2"
}

variable "storage_account_name_prefix" {
  description = "Prefix used to generate a globally unique storage account name."
  type        = string
  default     = "tfstatedemotfcicd"
}

variable "container_name" {
  description = "Blob container name for the Terraform state file."
  type        = string
  default     = "tfstate"
}

variable "tags" {
  description = "Tags applied to bootstrap resources."
  type        = map(string)
  default = {
    application = "demo-tf-cicd"
    purpose     = "terraform-state"
    owner       = "venkat-agents-lab"
  }
}
