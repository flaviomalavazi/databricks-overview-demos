# resource "aws_db_instance" "demo_rds" {
#   allocated_storage      = 20
#   identifier             = "${local.prefix}-mysql-db"
#   db_name                = "fleetmaintenance"
#   engine                 = "mysql"
#   engine_version         = "8.0.31"
#   instance_class         = "db.t3.micro"
#   username               = local.rds_admin_username
#   password               = local.rds_admin_password
#   parameter_group_name   = "default.mysql8.0"
#   skip_final_snapshot    = true
#   vpc_security_group_ids = module.databricks_workspace.vpc_security_group_ids
# }

