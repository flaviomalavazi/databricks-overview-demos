resource "aws_s3_bucket" "root_storage_bucket" {
  bucket        = "databricks-${local.prefix}-rootbucket"
  force_destroy = true
  tags          = merge(local.tags, { Name = "${local.prefix}-rootbucket" })
}

resource "aws_s3_bucket_versioning" "bucket_versioning_policy" {
  bucket = resource.aws_s3_bucket.root_storage_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_acl" "root_bucket_acl" {
  bucket = resource.aws_s3_bucket.root_storage_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "root_storage_bucket" {
  bucket             = resource.aws_s3_bucket.root_storage_bucket.id
  ignore_public_acls = true
  depends_on         = [resource.aws_s3_bucket.root_storage_bucket]
}

data "aws_iam_policy_document" "my_policy_document" {
  statement {
    sid    = "Grant Databricks Access"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::414351767826:root"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalTag/DatabricksAccountId"
      values   = ["${var.databricks_account_id}"]
    }

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]

    resources = [
      "${resource.aws_s3_bucket.root_storage_bucket.arn}/*",
      "${resource.aws_s3_bucket.root_storage_bucket.arn}"
    ]
  }
}


resource "aws_s3_bucket_policy" "root_bucket_policy" {
  bucket = resource.aws_s3_bucket.root_storage_bucket.id
  policy = data.aws_iam_policy_document.my_policy_document.json
}

resource "databricks_mws_storage_configurations" "this" {
  provider                   = databricks.mws
  account_id                 = var.databricks_account_id
  bucket_name                = resource.aws_s3_bucket.root_storage_bucket.bucket
  storage_configuration_name = "${local.prefix}-storage"
}


# Setup metastore bucket for Unity Catalog
/*

*/
resource "aws_s3_bucket" "metastore" {
  bucket        = "databricks-${local.prefix}-metastore"
  force_destroy = true
  tags          = merge(local.tags, { Name = "databricks-${local.prefix}-metastore" })
}


resource "aws_s3_bucket_versioning" "metastore_bucket_versioning_policy" {
  bucket = resource.aws_s3_bucket.metastore.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_acl" "metastore_bucket_acl" {
  bucket = resource.aws_s3_bucket.metastore.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "metastore_block_public_access" {
  bucket                  = aws_s3_bucket.metastore.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  depends_on              = [aws_s3_bucket.metastore]
}
