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
  backend "remote" {
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
