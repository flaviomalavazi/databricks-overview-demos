output "rds_arn" {
  value       = resource.aws_db_instance.this.arn
  description = "RDS ARN"
}

output "rds_address" {
  value       = resource.aws_db_instance.this.address
  description = "RDS Address"
}

output "rds_db_name" {
  value       = resource.aws_db_instance.this.db_name
  description = "RDS database name"
}

output "rds_endpoint" {
  value       = resource.aws_db_instance.this.endpoint
  description = "RDS Endpoint"
}

output "rds_db_port" {
  value       = resource.aws_db_instance.this.port
  description = "RDS Port"
}

output "security_group_ids" {
  value       = [module.vpc.default_security_group_id]
  description = "Security group ID for this VPC"
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID"
}

output "subnets" {
  value       = module.vpc.private_subnets
  description = "private subnets for workspace creation"
}

output "vpc_main_route_table_id" {
  value       = module.vpc.vpc_main_route_table_id
  description = "ID for the main route table associated with this VPC"
}
