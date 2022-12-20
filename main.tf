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

provider "azurerm" {
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = true
      recover_soft_deleted_secrets          = true
    }
  }
}

data "azurerm_client_config" "current" {}

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
output "azure_region" {
  value       = var.azure_region
  description = "Azure region that was passed in to the config"
}

# Azure Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "tf-learning-${local.environment}-rg"
  location = var.azure_region
  tags = {
    Environment = local.environment
    Team        = local.team
  }
}

# Azure Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "tf-learning-${local.environment}-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}