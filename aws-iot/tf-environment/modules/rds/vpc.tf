data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name = "${var.prefix}-rds-vpc"
  cidr = var.rds_cidr_block
  azs  = data.aws_availability_zones.available.names
  tags = var.tags

  enable_dns_hostnames = false
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

resource "aws_vpc_endpoint" "ec2" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.ec2"
  vpc_endpoint_type = "Interface"
  tags              = var.tags
}
