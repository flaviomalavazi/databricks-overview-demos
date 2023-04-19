resource "databricks_group" "workspace_level_group" {
  provider     = databricks.workspace
  display_name = "secret_scope_access_group"
}

resource "databricks_user" "workspace_secret_users" {
  provider  = databricks.workspace
  for_each  = toset(concat(var.databricks_users, var.databricks_metastore_admins))
  user_name = each.key
  force     = true
}

resource "databricks_group_member" "secret_access_group_membership" {
  provider  = databricks.workspace
  for_each  = toset(var.databricks_users)
  group_id  = databricks_group.workspace_level_group.id
  member_id = databricks_user.workspace_secret_users[each.value].id
}
