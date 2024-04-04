provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.0"
    }
  }
}

resource "azurerm_resource_group" "move2cloud" {
  name     = "move2cloud-resources"
  location = "East US"
}

