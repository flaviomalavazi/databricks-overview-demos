output "databricks_workspace_id" {
  value       = module.databricks_workspace.databricks_workspace_id
  description = "Databricks workspace ID"
}

output "databricks_workspace_url" {
  value       = module.databricks_workspace.databricks_host
  description = "Databricks workspace URL"
}

output "rds_arn" {
  value       = module.demo_rds.rds_arn
  description = "RDS ARN"
}

output "rds_address" {
  value       = module.demo_rds.rds_address
  description = "RDS Address"
}

output "rds_db_name" {
  value       = module.demo_rds.rds_db_name
  description = "RDS database name"
}

output "rds_endpoint" {
  value       = module.demo_rds.rds_endpoint
  description = "RDS Endpoint"
}

output "rds_db_port" {
  value       = module.demo_rds.rds_db_port
  description = "RDS Port"
}

output "kinesis_stream_arn" {
  value       = module.demo_kinesis.kinesis_stream_arn
  description = "ARN for the kinesis stream"
}

output "kinesis_stream_name" {
  value       = module.demo_kinesis.kinesis_stream_name
  description = "Name of the kinesis stream"
}

output "aws_services_role_arn" {
  value = resource.aws_iam_role.aws_services_role.arn
}

output "aws_services_role_name" {
  value = resource.aws_iam_role.aws_services_role.name
}

# output "databricks_sql_endoint_data_source_id" {
#   value = resource.databricks_sql_endpoint.demo_sql_warehouse.id
# }

output "s3_id" {
  value = module.demo_s3.s3_bucket_id
}
