resource "databricks_user" "unity_users" {
  provider  = databricks.mws
  for_each  = toset(concat(local.unity_user_list))
  user_name = each.key
  force     = true
}

resource "databricks_group" "unity_admin_group" {
  provider     = databricks.mws
  display_name = "${local.prefix}-uc-admins"
}

resource "databricks_group_member" "admin_group_member" {
  provider  = databricks.mws
  for_each  = toset(local.databricks_metastore_admins)
  group_id  = databricks_group.unity_admin_group.id
  member_id = databricks_user.unity_users[each.value].id
}

# resource "databricks_user_role" "metastore_admin" {
#   provider = databricks.mws
#   for_each = toset(local.databricks_metastore_admins)
#   user_id  = databricks_user.unity_users[each.value].id
#   role     = "account_admin"
# }
