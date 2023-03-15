resource "databricks_grants" "unity_catalog_grants" {
  provider  = databricks.workspace
  for_each  = toset(var.databricks_metastore_admins)
  metastore = module.unity_catalog.metastore_id
  grant {
    principal  = each.value
    privileges = ["CREATE_CATALOG", "CREATE_EXTERNAL_LOCATION"]
  }
}

resource "databricks_storage_credential" "external" {
  provider = databricks.workspace
  name     = "${resource.aws_iam_role.aws_services_role.name}-ext-cred"
  aws_iam_role {
    role_arn = resource.aws_iam_role.aws_services_role.arn
  }
  comment = "Managed by TF"
}

resource "databricks_grants" "external_creds_grants" {
  provider           = databricks.workspace
  storage_credential = resource.databricks_storage_credential.external.id
  grant {
    principal  = local.unity_admin_group
    privileges = ["ALL_PRIVILEGES"]
  }
}

resource "databricks_external_location" "landing" {
  provider        = databricks.workspace
  name            = "landing_zone"
  url             = "s3://${module.demo_s3.s3_bucket_id}/landing/${var.db_name}/"
  credential_name = databricks_storage_credential.external.id
  comment         = "Managed by TF"
  depends_on = [
    resource.databricks_group_member.service_principal_as_admin
  ]
}

resource "databricks_grants" "external_location_grants" {
  provider          = databricks.workspace
  external_location = resource.databricks_external_location.landing.id
  grant {
    principal  = local.unity_admin_group
    privileges = ["ALL_PRIVILEGES"]
  }
}


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
