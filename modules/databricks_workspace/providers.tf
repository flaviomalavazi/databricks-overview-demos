terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.48.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.4.1"
    }

    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }

    databricks = {
      source  = "databricks/databricks"
      version = "1.7.0"
    }

  }
}

provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

// initialize provider in "MWS" mode to provision new workspace
provider "databricks" {
  alias      = "mws"
  host       = "https://accounts.cloud.databricks.com"
  account_id = var.databricks_account_id
  username   = var.databricks_account_username
  password   = var.databricks_account_password
}

// initialize provider at account level for provisioning workspace with AWS PrivateLink
provider "databricks" {
  alias      = "workspace"
  account_id = var.databricks_account_id
  host       = resource.databricks_mws_workspaces.this.workspace_url
  username   = var.databricks_account_username
  password   = var.databricks_account_password
}