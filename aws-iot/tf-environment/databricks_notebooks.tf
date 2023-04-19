resource "databricks_notebook" "iot_demo_notebooks" {
  provider = databricks.workspace
  for_each = fileset("../iot_notebooks/", "*.py")
  source   = "../iot_notebooks/${each.value}"
  path     = "/iot_demo/${replace(each.value, ".py", "")}"
  format   = "SOURCE"
  depends_on = [
    module.databricks_workspace
  ]
}

# resource "databricks_notebook" "foreach_general_examples" {
#   for_each = fileset("../General_examples/", "*.py")
#   source   = "../General_examples/${each.value}"
#   path     = "${data.databricks_current_user.me.home}/General_examples/${replace(each.value, ".py", "")}"
#   depends_on = [
#     azurerm_databricks_workspace.databricks_demo_workspace
#   ]
# }

# data "databricks_notebook" "dlt_demo_notebook" {
#   path   = "${data.databricks_current_user.me.home}/DLT_Demo/DLT_Pipeline"
#   format = "SOURCE"
#   depends_on = [
#     resource.databricks_notebook.foreach_dlt,
#     resource.azurerm_databricks_workspace.databricks_demo_workspace
#   ]
# }
