variable "environment" {
  description = "The environment for which the resources are being created (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "created_by" {
  description = "The entity that created the resources"
  type        = string
  default     = "Terraform"
}
