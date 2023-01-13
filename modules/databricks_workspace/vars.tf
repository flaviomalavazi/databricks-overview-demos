
# Step 1: Initializing configs and variables 
variable "aws_profile" {}
variable "databricks_account_username" {}
variable "databricks_account_password" {}
variable "databricks_account_id" {}
variable "my_username" {}
variable "cross_account_role_name" {}
variable "unity_catalog_pass_role_name" {}

variable "tags" {
  default = ""
}

variable "prefix" {
  default = ""
}

variable "service_principal_display_name" {
  default = ""
}

variable "databricks_metastore_admins" {
  default = []
}

variable "unity_user_list" {
  default = []
}

variable "cidr_block" {
  default = "10.4.0.0/16"
}

variable "region" {
  default = "us-east-2"
}

resource "random_string" "naming_default" {
  special = false
  upper   = false
  length  = 6
}

locals {
  databricks_metastore_admins    = ["${var.my_username}"]
  unity_user_list                = ["${var.my_username}"]
  prefix                         = var.prefix
  service_principal_display_name = var.service_principal_display_name
  tags = {
    Environment = "Demo-with-terraform"
    Owner       = split("@", var.my_username)[0]
    OwnerEmail  = var.my_username
    KeepUntil   = "2023-01-31"
    Keep-Until  = "2023-01-31"
  }
}