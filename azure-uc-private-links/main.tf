module "databricks_workspace_private_links" {
  source              = "./modules/adb-private-links-general"
  resource_group_name = local.resource_group_name
  metastore_hosts     = local.metastore_hosts
  firewallfqdn        = local.firewallfqdn
  prefix              = local.prefix
  suffix              = local.suffix
  hubcidr             = local.hubcidr
  spokecidr           = local.spokecidr
  no_public_ip        = local.no_public_ip
  rglocation          = local.rglocation
  dbfs_prefix         = local.dbfs_prefix
  # tags                = local.tags
}

module "unity_catalog" {
  source                  = "./modules/azure_uc"
  resource_group_id       = module.databricks_workspace_private_links.resource_group_id
  suffix                  = local.suffix
  workspaces_to_associate = [tonumber(module.databricks_workspace_private_links.workspace_id)]
  depends_on = [
    module.databricks_workspace_private_links.workspace_id
  ]
}
