module "databricks_workspace" {
  source                         = "../../modules/databricks_workspace/"
  databricks_account_username    = var.databricks_account_username
  databricks_account_password    = var.databricks_account_password
  databricks_account_id          = var.databricks_account_id
  cross_account_role_name        = var.cross_account_role_name
  unity_catalog_pass_role_name   = var.unity_catalog_pass_role_name
  my_username                    = var.my_username
  aws_profile                    = var.aws_profile
  cidr_block                     = var.cidr_block
  region                         = var.region
  prefix                         = local.prefix
  service_principal_display_name = local.service_principal_display_name
  unity_user_list                = local.unity_user_list
  databricks_metastore_admins    = local.databricks_metastore_admins
  tags                           = local.tags
}