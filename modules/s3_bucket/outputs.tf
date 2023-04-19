output "s3_bucket_arn" {
    value = resource.aws_s3_bucket.this.arn
}

output "s3_bucket_id" {
    value = resource.aws_s3_bucket.this.id
}
