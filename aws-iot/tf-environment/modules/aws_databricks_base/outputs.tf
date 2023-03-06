output "security_group_ids" {
  value       = [module.vpc.default_security_group_id]
  description = "Security group ID for DB Compliant VPC"
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID"
}

output "subnets" {
  value       = module.vpc.private_subnets
  description = "private subnets for workspace creation"
}

output "root_bucket" {
  value       = aws_s3_bucket.root_storage_bucket.bucket
  description = "root bucket"
}