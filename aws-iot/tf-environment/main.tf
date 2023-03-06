module "aws_base" {
  providers = {
    databricks = databricks.mws
  }

  source     = "./modules/aws_databricks_base"
  tags       = local.tags
  prefix     = local.prefix
  cidr_block = var.cidr_block
  region     = var.region
}


module "databricks_workspace" {
  providers = {
    databricks = databricks.mws
  }
  source                 = "./modules/aws_databricks_workspace"
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

module "demo_kinesis" {
  source = "./modules/kinesis"
  tags   = local.tags
  prefix = local.prefix
}

module "demo_rds" {
  source                 = "./modules/rds"
  tags                   = local.tags
  prefix                 = local.prefix
  region                 = var.region
  rds_admin_username     = local.rds_admin_username
  rds_admin_password     = local.rds_admin_password
  rds_cidr_block         = var.rds_cidr_block
  db_name                = var.db_name
  vpc_security_group_ids = module.aws_base.security_group_ids
}
