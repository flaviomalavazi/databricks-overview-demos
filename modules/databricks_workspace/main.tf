/* 
Building blocks Setup
According to the tutorial in: https://docs.databricks.com/dev-tools/terraform/e2-workspace.html
we need to perform the following steps:
    1. Provide initialization variables for the workspace (file: variables.tf)
    2. Create a VPC with all the necessary firewall rules (file: vpc.tf)
    3. Create a root S3 bucket for the Databricks workspace (file: s3.tf)
    4. Create a cross account IAM role (file: iam.tf)
    5. Create the actual workspace (this file - main.tf)
    6. Manage resources in the workspace we created (files: databricks_*.tf)
*/

resource "databricks_mws_workspaces" "this" {
  provider                 = databricks.mws
  account_id               = var.databricks_account_id
  aws_region               = var.region
  workspace_name           = local.prefix
  deployment_name          = local.prefix
  credentials_id           = databricks_mws_credentials.this.credentials_id
  storage_configuration_id = databricks_mws_storage_configurations.this.storage_configuration_id
  network_id               = databricks_mws_networks.this.network_id

  token {
    comment = "Terraform"
  }

}
