
# Step 1: Initializing configs and variables 
variable "tags" {
  type        = map(any)
  description = "(Optional) List of tags to be propagated accross all assets in this demo"
}

variable "cidr_block" {
  type        = string
  description = "(Required) CIDR block to be used to create the Databricks VPC"
}

variable "rds_cidr_block" {
  type        = string
  description = "(Optional) CIDR block to be used to create the RDS VPC (should not overlap with the Databricks one)"
  default     = "10.1.0.0/24"
}

variable "region" {
  type        = string
  description = "(Required) AWS region where the assets will be deployed"
}

variable "aws_profile" {
  type        = string
  description = "(Required) AWS cli profile to be used for authentication with AWS"
}

data "aws_caller_identity" "current" {}

variable "my_username" {
  type        = string
  description = "(Required) Username in the form of an email to be added to the tags and be declared as owner of the assets"
}

variable "databricks_sp_oauth_client_id" {
  type        = string
  description = "(Required) Service Principal OAuth client ID to authenticate with Databricks"
}

variable "databricks_sp_oauth_secret" {
  type        = string
  description = "(Required) Service Principal OAuth client secret to authenticate with Databricks"
}

variable "databricks_sp_name" {
  type        = string
  description = "(Required) Databricks Service Principal name"
}

variable "databricks_account_id" {
  type        = string
  description = "(Required) Databricks Account ID"
}

resource "random_string" "naming" {
  special = false
  upper   = false
  length  = 6
}

resource "random_string" "rds_admin_password" {
  special          = false
  upper            = true
  override_special = "!#$&="
  length           = 32
}

variable "db_name" {
  type        = string
  description = "(Optional) database name for the db within MySQL, defaults to `fleetmaintenance`"
  default     = "fleetmaintenance"
}


variable "databricks_users" {
  description = <<EOT
  List of Databricks users to be added at account-level for Unity Catalog.
  Enter with square brackets and double quotes
  e.g ["first.last@domain.com", "second.last@domain.com"]
  EOT
  type        = list(string)
}

variable "databricks_metastore_admins" {
  description = <<EOT
  List of Admins to be added at account-level for Unity Catalog.
  Enter with square brackets and double quotes
  e.g ["first.admin@domain.com", "second.admin@domain.com"]
  EOT
  type        = list(string)
}

variable "unity_admin_group" {
  description = "Name of the admin group. This group will be set as the owner of the Unity Catalog metastore"
  type        = string
}

variable "bucket_name" {
  type        = string
  description = "(Optional) Name for the bucket managed by this module"
  default     = null
}

variable "aws_access_services_role_name" {
  type        = string
  description = "(Optional) Name for the AWS Services role by this module"
  default     = null
}
locals {
  prefix                         = "demo-${random_string.naming.result}"
  unity_admin_group              = "${local.prefix}-${var.unity_admin_group}"
  aws_access_services_role_name  = var.aws_access_services_role_name == null ? "${local.prefix}-aws-services-role" : "${local.prefix}-${var.aws_access_services_role_name}"
  aws_access_services_role_arn   = "arn:aws:iam::${local.aws_account_id}:role/${local.aws_access_services_role_name}"
  aws_account_id                 = data.aws_caller_identity.current.account_id
  rds_admin_username             = "admin${random_string.naming.result}"
  rds_admin_password             = resource.random_string.rds_admin_password.result
  bucket_name                    = var.bucket_name == null ? "demo-${resource.random_string.naming.result}-s3-bucket" : var.bucket_name
  service_principal_display_name = "Automation-only SP"
  tags                           = merge(var.tags, { Owner = split("@", var.my_username)[0], ownerEmail = var.my_username })
}