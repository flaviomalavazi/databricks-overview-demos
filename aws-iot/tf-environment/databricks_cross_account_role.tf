data "databricks_aws_assume_role_policy" "this" {
  external_id = var.databricks_account_id
}

resource "aws_iam_role" "cross_account_role" {
  name               = "${local.prefix}-crossaccount"
  assume_role_policy = data.databricks_aws_assume_role_policy.this.json
  tags               = var.tags
}

data "aws_iam_policy_document" "serverless_assume_role_policy" {
  statement {
    sid       = "serverlessAssumeRole"
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::790110701330:role/serverless-customer-resource-role"]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"

      values = [
        "databricks-serverless-${module.databricks_workspace.databricks_workspace_id}",
      ]
    }
  }
}

# resource "aws_iam_role_policy" "serverless_policy" {
#   role        = aws_iam_role.cross_account_role.name
#   policy      = data.aws_iam_policy_document.serverless_assume_role_policy.json
# }

# resource "aws_iam_role_policy_attachment" "serverless_policy_attachment" {
#   role       = aws_iam_role.cross_account_role.name
#   policy_arn = aws_iam_role_policy.serverless_policy.arn
# }

data "databricks_aws_crossaccount_policy" "this" {
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
