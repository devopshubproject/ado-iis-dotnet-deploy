### Providers Configuration for Azure ###
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Configure the AzureRM provider
provider "azurerm" {
  features {}
}