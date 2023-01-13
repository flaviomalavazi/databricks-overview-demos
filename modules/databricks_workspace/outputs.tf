output "databricks_host" {
  value = databricks_mws_workspaces.this.workspace_url
}

output "databricks_token" {
  value     = databricks_mws_workspaces.this.token[0].token_value
  sensitive = true
}

output "databricks_workspace_id" {
  value = databricks_mws_workspaces.this.workspace_id
}

output "databricks_metastore_id" {
  value = resource.databricks_metastore.this.id
}

output "vpc_security_group_ids" {
  value = [module.vpc.default_security_group_id]
}
