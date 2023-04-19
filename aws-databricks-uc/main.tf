module "aws_base" {
  providers = {
    databricks.mws = databricks.mws
  }
  source                = "../modules/aws_databricks_base"
  tags                  = local.tags
  prefix                = local.prefix
  cidr_block            = var.cidr_block
  region                = var.region
  databricks_account_id = var.databricks_account_id
  roles_to_assume       = [local.aws_access_services_role_arn]
}

module "databricks_workspace" {
  providers = {
    databricks.mws       = databricks.mws
    databricks.workspace = databricks.workspace
  }
  source                 = "../modules/aws_databricks_workspace"
  region                 = var.region
  databricks_account_id  = var.databricks_account_id
  security_group_ids     = module.aws_base.security_group_ids
  vpc_private_subnets    = module.aws_base.subnets
  vpc_id                 = module.aws_base.vpc_id
  root_storage_bucket    = module.aws_base.root_bucket
  cross_account_role_arn = module.aws_base.cross_account_role_arn
  prefix                 = local.prefix
  tags                   = local.tags
  depends_on = [
    module.aws_base
  ]
}

module "unity_catalog" {
  source = "../modules/aws_databricks_unity_catalog"
  providers = {
    databricks.mws       = databricks.mws
    databricks.workspace = databricks.workspace
  }
  region                   = var.region
  databricks_account_id    = var.databricks_account_id
  aws_account_id           = local.aws_account_id
  prefix                   = local.prefix
  tags                     = local.tags
  unity_metastore_owner    = local.unity_admin_group
  databricks_workspace_ids = [module.databricks_workspace.databricks_workspace_id]
  depends_on = [
    module.databricks_workspace,
    resource.databricks_group.admin_group
  ]
}
