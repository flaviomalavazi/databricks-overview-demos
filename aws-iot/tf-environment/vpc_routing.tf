
resource "aws_vpc_peering_connection" "this" {
  peer_owner_id = local.aws_account_id
  peer_vpc_id   = module.demo_rds.vpc_id
  vpc_id        = module.aws_base.vpc_id
  auto_accept   = true
  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_route" "db_to_rds" {
  count                     = length(module.aws_base.private_route_table_ids)
  route_table_id            = module.aws_base.private_route_table_ids[count.index]
  destination_cidr_block    = var.rds_cidr_block
  vpc_peering_connection_id = resource.aws_vpc_peering_connection.this.id
}

resource "aws_route" "rds_to_db" {
  count                     = length(module.demo_rds.private_route_table_ids)
  route_table_id            = module.demo_rds.private_route_table_ids[count.index]
  destination_cidr_block    = var.cidr_block
  vpc_peering_connection_id = resource.aws_vpc_peering_connection.this.id
}

resource "aws_security_group_rule" "example" {
  type                     = "ingress"
  cidr_blocks              = [var.cidr_block]
  to_port                  = 3306
  from_port                = 3306
  protocol                 = "tcp"
  security_group_id        = module.demo_rds.security_group_ids[0]
}
