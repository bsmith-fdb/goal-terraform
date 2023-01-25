terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.19.0"
    }
  }

  required_version = ">= 1.1.0"
}

data "azurerm_client_config" "current" {}

provider "azurerm" {
  features {}
}

# Input variables passed in to the config
variable "azure_region" {
  type        = string
  default     = "eastus2"
  description = "Azure region"
}

# Local variables used within the config
locals {
  environment = terraform.workspace
  team        = "apollo"
}

# Output variables "returned" from the config
output "resource_group_id" {
  value       = azurerm_resource_group.my_rg.id
  description = "Resource Group ID"
}

# Azure Virtual Network
resource "azurerm_virtual_network" "my_vnet" {
  name                = "tf-learning-${local.environment}-vnet"
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name
  address_space       = ["10.0.0.0/16"]
}

# Azure Storage Account
resource "azurerm_storage_account" "my_sa" {
  name                     = "tflearning${local.environment}sa"
  location                 = azurerm_resource_group.my_rg.location
  resource_group_name      = azurerm_resource_group.my_rg.name
  account_tier             = "Standard"
  account_replication_type = "GRS"
  tags = {
    Environment = local.environment
    Team        = local.team
  }
}

# Azure Resource Group
resource "azurerm_resource_group" "my_rg" {
  name     = "tf-learning-${local.environment}-rg"
  location = var.azure_region
  tags = {
    Environment = local.environment
    Team        = local.team
  }
}