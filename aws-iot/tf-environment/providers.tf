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

// initialize provider in normal mode
provider "databricks" {
  host  = module.databricks_workspace.databricks_host
  token = module.databricks_workspace.databricks_token
}
