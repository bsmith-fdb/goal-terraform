# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {
    key_vault {
        purge_soft_deleted_secrets_on_destroy = true
        recover_soft_deleted_secrets = true
    }
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
    name = "tf-learning-${terraform.workspace}-kv"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    tenant_id = data.azurerm_client_config.current.tenant_id
    soft_delete_retention_days = 7
    purge_protection_enabled = false
    sku_name = "standard"
}

resource "azurerm_resource_group" "rg" {
  name     = "tf-learning-${terraform.workspace}-rg"
  location = "eastus2"

  tags = {
    Environment = "${terraform.workspace}"
    Team = "apollo"
  }
}
