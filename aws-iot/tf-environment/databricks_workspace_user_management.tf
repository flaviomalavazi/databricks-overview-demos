# data "databricks_group" "admins" {
#   display_name = "admins"
#   depends_on = [
#     module.databricks_workspace
#   ]
# }

# resource "databricks_user" "me" {
#   user_name = var.my_username
#   depends_on = [
#     module.databricks_workspace
#   ]
# }

# resource "databricks_group_member" "i_am_admin" {
#   group_id  = data.databricks_group.admins.id
#   member_id = databricks_user.me.id
#   depends_on = [
#     data.databricks_group.admins,
#     resource.databricks_user.me
#   ]
# }
