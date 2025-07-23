variable "environment" {
  description = "The environment for which the resources are being created (e.g., dev, prod)"
  type        = string
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
