resource "databricks_metastore" "this" {
  provider      = databricks.workspace
  name          = local.metastore_name
  owner         = var.unity_metastore_owner
  storage_root  = "s3://${aws_s3_bucket.metastore.id}/metastore"
  force_destroy = true
}

resource "databricks_metastore_data_access" "this" {
  provider     = databricks.workspace
  metastore_id = databricks_metastore.this.id
  name         = aws_iam_role.metastore_data_access.name
  aws_iam_role {
    role_arn = aws_iam_role.metastore_data_access.arn
  }
  is_default = true
}

resource "databricks_metastore_assignment" "default_metastore" {
  provider             = databricks.workspace
  count                = length(var.databricks_workspace_ids)
  workspace_id         = var.databricks_workspace_ids[count.index]
  metastore_id         = databricks_metastore.this.id
  default_catalog_name = "hive_metastore"
}
