resource "databricks_secret_scope" "rds" {
  provider = databricks.workspace
  name     = "rds_scope"
  depends_on = [
    module.databricks_workspace
  ]
}

resource "databricks_secret_acl" "rds_acl" {
  provider   = databricks.workspace
  principal  = resource.databricks_group.workspace_level_group.display_name
  scope      = databricks_secret_scope.rds.name
  permission = "READ"
  depends_on = [
    resource.databricks_group.workspace_level_group
  ]
}

resource "databricks_secret" "rds_host" {
  provider     = databricks.workspace
  key          = "host"
  string_value = module.demo_rds.rds_address
  scope        = databricks_secret_scope.rds.id
}

resource "databricks_secret" "rds_port" {
  provider     = databricks.workspace
  key          = "port"
  string_value = module.demo_rds.rds_db_port
  scope        = databricks_secret_scope.rds.id
}

resource "databricks_secret" "rds_db_name" {
  provider     = databricks.workspace
  key          = "database"
  string_value = module.demo_rds.rds_db_name
  scope        = databricks_secret_scope.rds.id
}

resource "databricks_secret" "rds_username" {
  provider     = databricks.workspace
  key          = "username"
  string_value = local.rds_admin_username
  scope        = databricks_secret_scope.rds.id
}

resource "databricks_secret" "rds_password" {
  provider     = databricks.workspace
  key          = "password"
  string_value = local.rds_admin_password
  scope        = databricks_secret_scope.rds.id
}

resource "databricks_secret_scope" "kinesis" {
  provider = databricks.workspace
  name     = "kinesis_scope"
  depends_on = [
    module.databricks_workspace
  ]
}

resource "databricks_secret_acl" "kinesis_acl" {
  provider   = databricks.workspace
  principal  = resource.databricks_group.workspace_level_group.display_name
  scope      = databricks_secret_scope.kinesis.name
  permission = "READ"
  depends_on = [
    resource.databricks_group.workspace_level_group
  ]
}

resource "databricks_secret" "stream_arn" {
  provider     = databricks.workspace
  key          = "kinesis_stream_arn"
  string_value = module.demo_kinesis.kinesis_stream_arn
  scope        = databricks_secret_scope.kinesis.id
}

resource "databricks_secret" "stream_name" {
  provider     = databricks.workspace
  key          = "kinesis_stream_name"
  string_value = module.demo_kinesis.kinesis_stream_name
  scope        = databricks_secret_scope.kinesis.id
}

resource "databricks_secret" "stream_region" {
  provider     = databricks.workspace
  key          = "kinesis_stream_region"
  string_value = var.region
  scope        = databricks_secret_scope.kinesis.id
}

resource "databricks_secret_scope" "s3_scope" {
  provider = databricks.workspace
  name     = "demo_s3"
  depends_on = [
    module.databricks_workspace
  ]
}

resource "databricks_secret_acl" "s3_acl" {
  provider   = databricks.workspace
  principal  = resource.databricks_group.workspace_level_group.display_name
  scope      = databricks_secret_scope.s3_scope.name
  permission = "READ"
  depends_on = [
    resource.databricks_group.workspace_level_group
  ]
}

resource "databricks_secret" "s3_name" {
  provider     = databricks.workspace
  key          = "bucket_name"
  string_value = local.bucket_name
  scope        = databricks_secret_scope.s3_scope.id
}
