terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "Terraform-AzureDevops"
    storage_account_name = "terraformremotestate42"
    container_name       = "terraformstate-lessons"
    key                  = "zero/state.tfstate"
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  features {}
}

provider "random" {}
