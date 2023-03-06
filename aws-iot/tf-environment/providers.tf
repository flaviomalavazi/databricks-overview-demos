provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

// initialize provider in normal mode
provider "databricks" {
  alias          = "mws"
  host           = "https://accounts.cloud.databricks.com"
  token_endpoint = "https://accounts.cloud.databricks.com/oidc/accounts/${var.databricks_account_id}/v1/token"
  client_id      = var.databricks_sp_oauth_client_id
  client_secret  = var.databricks_sp_oauth_secret
}

provider "databricks" {
  alias = "workspace"
  host  = module.databricks_workspace.databricks_host
  token = module.databricks_workspace.databricks_token
}
