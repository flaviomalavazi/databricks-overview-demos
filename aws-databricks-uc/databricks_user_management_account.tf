resource "databricks_user" "unity_users" {
  provider  = databricks.mws
  for_each  = toset(concat(var.databricks_users, var.databricks_metastore_admins))
  user_name = each.key
  force     = true
}

resource "databricks_group" "admin_group" {
  provider     = databricks.mws
  display_name = local.unity_admin_group
}

data "databricks_service_principals" "spns" {
  provider              = databricks.mws
  display_name_contains = var.databricks_sp_name
}

data "databricks_service_principal" "spn" {
  provider       = databricks.mws
  for_each       = toset(data.databricks_service_principals.spns.application_ids)
  application_id = each.value
}

resource "databricks_mws_permission_assignment" "add_admin_group" {
  provider     = databricks.mws
  workspace_id = module.databricks_workspace.databricks_workspace_id
  principal_id = resource.databricks_group.admin_group.id
  permissions  = ["ADMIN"]
}

resource "databricks_group_member" "admin_group_member" {
  provider  = databricks.mws
  for_each  = toset(var.databricks_metastore_admins)
  group_id  = databricks_group.admin_group.id
  member_id = databricks_user.unity_users[each.value].id
}

resource "databricks_group_member" "service_principal_as_admin" {
  provider  = databricks.mws
  for_each  = toset(data.databricks_service_principals.spns.application_ids)
  group_id  = resource.databricks_group.admin_group.id
  member_id = data.databricks_service_principal.spn[each.value].sp_id
}
