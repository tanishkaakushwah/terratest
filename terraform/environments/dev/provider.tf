terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.49.0"
    }
  }
  backend "azurerm" {
    subscription_id = "009fad33-c09c-4841-af38-57dd79870d40"
    resource_group_name  = "rg-dhondu"
    storage_account_name = "tfstatesdhondhuwalaaa"
    container_name       = "tfstates"
    key                  = "dev.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "009fad33-c09c-4841-af38-57dd79870d40"
}
