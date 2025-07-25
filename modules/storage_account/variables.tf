variable "environment" {
  description = "The environment for which the resources are being created (e.g., dev, prod)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{1,7}$", var.environment))
    error_message = "Environment must be 1–7 lowercase alphanumeric characters to ensure storage account name length ≤24."
  }
}

variable "created_by" {
  description = "The entity that created the resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the existing resource group"
  type        = string
}

variable "resource_group_location" {
  description = "Location of the existing resource group"
  type        = string
}
