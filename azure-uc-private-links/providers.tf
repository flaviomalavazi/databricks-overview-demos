# versions.tf
terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = ">=1.9.1"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.41.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }

  }
}

provider "azurerm" {
  features {}
}

provider "databricks" {
  host = module.databricks_workspace_private_links.workspace_url
}