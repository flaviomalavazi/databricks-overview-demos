resource "databricks_metastore" "this" {
  provider      = databricks.workspace
  name          = "primary"
  storage_root  = "s3://${resource.aws_s3_bucket.metastore.id}/metastore"
  owner         = var.my_username
  force_destroy = true
}

resource "databricks_metastore_data_access" "this" {
  provider     = databricks.workspace
  metastore_id = databricks_metastore.this.id
  name         = data.aws_iam_role.unity_catalog_pass_role.name
  aws_iam_role {
    role_arn = data.aws_iam_role.unity_catalog_pass_role.arn
  }
  is_default = true
  depends_on = [
    resource.databricks_metastore_assignment.default_metastore
  ]
}

resource "databricks_metastore_assignment" "default_metastore" {
  provider             = databricks.workspace
  workspace_id         = resource.databricks_mws_workspaces.this.workspace_id
  metastore_id         = resource.databricks_metastore.this.id
  default_catalog_name = "hive_metastore"
  depends_on = [
    resource.databricks_metastore.this
  ]
}
