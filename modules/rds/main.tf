resource "aws_db_subnet_group" "this" {
  name       = "${var.prefix}-mysql-db-subnet-group"
  subnet_ids = module.vpc.private_subnets
}

resource "aws_db_instance" "this" {
  allocated_storage      = 20
  identifier             = "${var.prefix}-mysql-db"
  multi_az               = false
  db_name                = var.db_name
  engine                 = "mysql"
  engine_version         = "8.0.31"
  instance_class         = "db.t4g.micro"
  username               = var.rds_admin_username
  password               = var.rds_admin_password
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  db_subnet_group_name   = resource.aws_db_subnet_group.this.id
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  tags                   = merge(var.tags, { Name = "${var.prefix}-db" })
}

