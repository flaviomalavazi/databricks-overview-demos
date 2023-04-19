resource "databricks_grants" "unity_catalog_grants" {
  provider  = databricks.workspace
  for_each  = toset(var.databricks_metastore_admins)
  metastore = module.unity_catalog.metastore_id
  grant {
    principal  = each.value
    privileges = ["CREATE_CATALOG", "CREATE_EXTERNAL_LOCATION"]
  }
  depends_on = [
    resource.time_sleep.wait
  ]
}

# Sleeping for 20s to wait for the workspace to enable identity federation
resource "time_sleep" "wait" {
  depends_on = [
    module.unity_catalog
  ]
  create_duration = "20s"
}
