
# Step 1: Initializing configs and variables 
variable "tags" {
  default = ""
}

variable "cidr_block" {
  default = "10.4.0.0/16"
}

variable "region" {
  default = "us-east-2"
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

locals {
  prefix                         = "demo-latam-${random_string.naming.result}"
  rds_admin_username             = "${var.rds_admin_password_prefix}${random_string.naming.result}"
  rds_admin_password             = resource.random_string.rds_admin_password.result
  service_principal_display_name = "Automation-only SP"
  unity_user_list                = ["${var.my_username}"]
  databricks_metastore_admins    = ["${var.my_username}"]
  tags = {
    Environment = "Demo-with-terraform"
    Owner       = split("@", var.my_username)[0]
    OwnerEmail  = var.my_username
    KeepUntil   = "2023-01-31"
    Keep-Until  = "2023-01-31"
  }
}