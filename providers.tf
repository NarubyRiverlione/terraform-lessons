terraform {
  required_version = ">= 1.5.0"
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
  cloud {
    organization = "naruby-riverlione-org"
    workspaces {
      name = "Zero-module"
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  features {}
}

provider "random" {}
