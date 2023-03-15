module "aws_base" {
  providers = {
    databricks = databricks.mws
  }
  source     = "../../modules/aws_databricks_base"
  tags       = local.tags
  prefix     = local.prefix
  cidr_block = var.cidr_block
  region     = var.region
}


module "databricks_workspace" {
  providers = {
    databricks.mws       = databricks.mws
    databricks.workspace = databricks.workspace
  }
  source                 = "../../modules/aws_databricks_workspace"
  region                 = var.region
  databricks_account_id  = var.databricks_account_id
  security_group_ids     = module.aws_base.security_group_ids
  vpc_private_subnets    = module.aws_base.subnets
  vpc_id                 = module.aws_base.vpc_id
  root_storage_bucket    = module.aws_base.root_bucket
  cross_account_role_arn = resource.aws_iam_role.cross_account_role.arn
  prefix                 = local.prefix
  tags                   = local.tags
  depends_on = [
    module.aws_base
  ]
}

module "unity_catalog" {
  source = "../../modules/aws_databricks_unity_catalog"
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

module "demo_kinesis" {
  source = "../../modules/kinesis"
  tags   = local.tags
  prefix = local.prefix
}


module "demo_s3" {
  source      = "../../modules/s3_bucket"
  bucket_name = local.bucket_name
  tags        = local.tags
}

module "demo_rds" {
  source                 = "../../modules/rds"
  tags                   = local.tags
  prefix                 = local.prefix
  region                 = var.region
  rds_admin_username     = local.rds_admin_username
  rds_admin_password     = local.rds_admin_password
  rds_cidr_block         = var.rds_cidr_block
  db_name                = var.db_name
  vpc_security_group_ids = module.aws_base.security_group_ids
}

# module "iot_dashboards" {
#   source = "../iot_dashboards/"
#   providers = {
#     databricks = databricks.workspace
#   }
#   warehouse_data_source_id = resource.databricks_sql_endpoint.demo_sql_warehouse.id
#   depends_on = [
#     resource.databricks_sql_endpoint.demo_sql_warehouse
#   ]
# }
