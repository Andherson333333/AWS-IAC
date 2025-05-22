################################################################
# VPC Peering Connection
################################################################
module "vpc_peering" {
  source  = "grem11n/vpc-peering/aws"
  version = "6.0.0"

  providers = {
    aws.this = aws.virginia
    aws.peer = aws.virginia
  }

  this_vpc_id = module.vpc_1.vpc_id
  peer_vpc_id = module.vpc_2.vpc_id

  auto_accept_peering = true

  # Tablas de ruta de VPC-1
  this_rts_ids = concat(
    module.vpc_1.private_route_table_ids,
    module.vpc_1.public_route_table_ids
  )

  # Tablas de ruta de VPC-2
  peer_rts_ids = concat(
    module.vpc_2.private_route_table_ids,
    module.vpc_2.public_route_table_ids
  )

  tags = local.tags
}
