terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.49.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-dhondu"
    storage_account_name = "tfstatesdhondhuwalaa"
    container_name       = "tfstates"
    key                  = "dev.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "c0748677-9808-4356-8816-dc8088c5bb59"
}
