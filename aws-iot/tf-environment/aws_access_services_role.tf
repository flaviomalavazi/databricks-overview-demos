data "aws_iam_policy_document" "assume_role_for_ec2" {
  statement {
    sid     = "AllowEC2ToAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }

  statement {
    sid     = "AllowUnityCatalogToAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::414351767826:role/unity-catalog-prod-UCMasterRole-14S5ZJVKOTYTL",
      local.aws_access_services_role_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.databricks_account_id]
    }
  }

}

resource "aws_iam_role" "aws_services_role" {
  name               = "${local.aws_access_services_role_name}"
  description        = "Shared Role to access other AWS Services (s3, Kinesis...)"
  assume_role_policy = data.aws_iam_policy_document.assume_role_for_ec2.json
  tags               = local.tags
}


data "aws_iam_policy_document" "aws_services_role_policy_document" {
  # Allows read and put to Kinesis streams
  statement {
    sid       = "allowInteractionWithKinesis"
    effect    = "Allow"
    actions   = ["kinesis:Get*",
    "kinesis:DescribeStream",
    "kinesis:ListShards",
    "kinesis:PutRecord",
    "kinesis:PutRecords"]
    resources = [module.demo_kinesis.kinesis_stream_arn]
  }

  statement {
    sid    = "s3AccessWithUC"
    effect = "Allow"
    actions = ["s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetLifecycleConfiguration",
      "s3:PutLifecycleConfiguration"
    ]
    resources = ["${module.demo_s3.s3_bucket_arn}", "${module.demo_s3.s3_bucket_arn}/*"]
  }

  statement {
    sid       = "allowUCAssumeRole"
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = [local.aws_access_services_role_arn]
  }

}

resource "aws_iam_role_policy" "aws_services_role_policy" {
  name   = "${local.prefix}-aws-services-policy"
  role   = aws_iam_role.aws_services_role.id
  policy = data.aws_iam_policy_document.aws_services_role_policy_document.json
}

resource "aws_iam_instance_profile" "shared" {
  name = "${local.prefix}-shared-instance-profile"
  role = aws_iam_role.aws_services_role.name
}
