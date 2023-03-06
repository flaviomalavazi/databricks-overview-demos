# resource "databricks_grants" "unity_catalog_grants" {
#   metastore = module.databricks_workspace.databricks_metastore_id
#   grant {
#     principal  = var.my_username
#     privileges = ["CREATE_CATALOG", "CREATE_EXTERNAL_LOCATION"]
#   }
# }

# resource "databricks_grants" "unity_catalog_authenticator_grants" {
#   metastore = module.databricks_workspace.databricks_metastore_id
#   grant {
#     principal  = var.databricks_account_username
#     privileges = ["CREATE_CATALOG", "CREATE_EXTERNAL_LOCATION"]
#   }
# }

# resource "databricks_catalog" "dev_catalog" {
#   metastore_id = module.databricks_workspace.databricks_metastore_id
#   name         = "dev"
#   comment      = "This catalog is managed by terraform"
#   properties = {
#     purpose = "Demonstrating governance with terraform"
#   }
#   depends_on = [
#     resource.databricks_grants.unity_catalog_authenticator_grants
#   ]
# }

# resource "databricks_grants" "dev_catalog_grants" {
#   catalog = resource.databricks_catalog.dev_catalog.name
#   grant {
#     principal  = var.my_username
#     privileges = ["USE_CATALOG", "USE_SCHEMA", "CREATE_SCHEMA", "CREATE_TABLE", "MODIFY"]
#   }
# }
