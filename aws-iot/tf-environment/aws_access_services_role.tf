data "aws_iam_policy_document" "assume_role_for_ec2" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "aws_services_role" {
  name               = "${local.prefix}-aws-services-role"
  description        = "Shared Role to access other AWS Services (s3, Kinesis...)"
  assume_role_policy = data.aws_iam_policy_document.assume_role_for_ec2.json
  tags               = local.tags
}


data "aws_iam_policy_document" "aws_services_role_policy_document" {
  # Allows read and put to Kinesis streams
  statement {
    sid       = "allowInteractionWithKinesis"
    effect    = "Allow"
    actions   = ["kinesis:Get*", "kinesis:DescribeStream", "kinesis:PutRecord", "kinesis:PutRecords"]
    resources = [module.demo_kinesis.kinesis_stream_arn]
  }
}

resource "aws_iam_role_policy" "aws_services_role_policy" {
  name   = "${local.prefix}-aws-services-policy"
  role   = aws_iam_role.aws_services_role.id
  policy = data.aws_iam_policy_document.aws_services_role_policy_document.json
}

resource "aws_iam_instance_profile" "shared" {
  name = "shared-instance-profile"
  role = aws_iam_role.aws_services_role.name
}

resource "databricks_instance_profile" "shared" {
  provider             = databricks.workspace
  instance_profile_arn = aws_iam_instance_profile.shared.arn
}
