variable "bootstrap" {
  type        = bool
  description = "(Optional) Helps to bootstrap the workspace as we need its ID to setup serverless later on"
  default     = false
}

data "databricks_aws_assume_role_policy" "this" {
  provider    = databricks.mws
  external_id = var.databricks_account_id
}

resource "aws_iam_role" "cross_account_role" {
  name               = "${local.prefix}-crossaccount"
  assume_role_policy = var.bootstrap ? data.databricks_aws_assume_role_policy.this.json : data.aws_iam_policy_document.serverless_assume_role_policy[0].json
  tags               = var.tags
}

data "aws_iam_policy_document" "serverless_assume_role_policy" {
  count                   = var.bootstrap ? 0 : 1
  source_policy_documents = [data.databricks_aws_assume_role_policy.this.json]
  statement {
    sid     = "serverlessAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::790110701330:role/serverless-customer-resource-role"]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values = [
        "databricks-serverless-<DATABRICKS_WORKSPACE_ID>"
      ]
    }
  }
} # ${module.databricks_workspace.databricks_workspace_id}

data "databricks_aws_crossaccount_policy" "this" {
  provider = databricks.mws
}

data "aws_iam_policy_document" "this" {
  source_policy_documents = [data.databricks_aws_crossaccount_policy.this.json]
  statement {
    sid       = "allowPassCrossServiceRole"
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = [resource.aws_iam_role.aws_services_role.arn]
  }
}

resource "aws_iam_role_policy" "this" {
  name   = "${local.prefix}-policy"
  role   = aws_iam_role.cross_account_role.id
  policy = data.aws_iam_policy_document.this.json
}
