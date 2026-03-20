variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
  default     = "terraform-rg"
}

variable "location" {
  type        = string
  description = "Azure region to deploy resources"
  default     = "Central India"
}

variable "storage_account_tier" {
  type        = string
  description = "Tier of the storage account"
  default     = "Standard"
}
