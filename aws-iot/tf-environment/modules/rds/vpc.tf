data "aws_availability_zones" "available" {}
/*
resource "aws_vpc" "this" {
  name = "${var.prefix}-rds-vpc"
  cidr_block = var.rds_cidr_block
  enable_dns_hostnames = true
  tags = merge(var.tags, { Name = "${var.prefix}-rds-vpc" })
}

resource "aws_subnet" "public_subnet" {
  count = length(local.public_subnets)
  vpc_id = resource.aws_vpc.this.id
  cidr_block = local.public_subnets[count.index]
  availability_zone = data.aws_availability_zones.available[count.index]
  tags = merge(var.tags, { Name = "${var.prefix}-rds-public-subnet-${count.index}" })
}

resource "aws_subnet" "private_subnet" {
  count = length(local.private_subnets)
  vpc_id = resource.aws_vpc.this.id
  cidr_block = local.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.available[count.index]
  tags = merge(var.tags, { Name = "${var.prefix}-rds-private-subnet-${count.index}" })
}

resource "aws_route_table" "private_route_table" {
  vpc_id = resource.aws_vpc.this.id
}

resource "aws_route_table_association" "private" {
  count = length(local.private_subnets)
  route_table_id = resource.aws_route_table.private_route_table.id
  subnet_id = resource.aws_subnet.private_subnet[count.index].id
}

resource "aws_security_group" "private_security_group" {
  name = "${var.prefix}-rds-vpc-private-sg"
  description = "Private security group for the RDS VPC"
  vpc_id = resource.aws_vpc.this.id
  ingress {
    description = "Allow inbound traffic to port 3306"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = resource.aws_security_group.
  }
}

resource "aws_db_subnet_group" "this" {
  name = "${local.prefix}-db-subnet-group"
  description = "DB Subnet group for the RDS"
  subnet_ids = [for subnet in resource.aws_subnet.private_subnet : subnet.id]
}
*/

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name = "${var.prefix}-rds-vpc"
  cidr = var.rds_cidr_block
  azs  = data.aws_availability_zones.available.names
  tags = var.tags

  enable_dns_hostnames = true
  enable_nat_gateway   = false
  single_nat_gateway   = false
  create_igw           = false

  public_subnets  = [cidrsubnet(var.rds_cidr_block, 3, 0)]
  private_subnets = [cidrsubnet(var.rds_cidr_block, 3, 1), cidrsubnet(var.rds_cidr_block, 3, 2)]

  manage_default_security_group = true
  default_security_group_name   = "${var.prefix}-rds-sg"

  default_security_group_egress = [{
    cidr_blocks = "0.0.0.0/0"
  }]

  default_security_group_ingress = [{
    description = "Allow all internal TCP and UDP"
    self        = true
  }]
}

# resource "aws_vpc_endpoint" "ec2" {
#   vpc_id            = module.vpc.vpc_id
#   service_name      = "com.amazonaws.${var.region}.ec2"
#   vpc_endpoint_type = "Interface"
#   tags              = var.tags
# }
