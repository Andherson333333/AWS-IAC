################################################################
# VPN Gateway Module
################################################################

module "vpn_gateway" {
  source  = "terraform-aws-modules/vpn-gateway/aws"
  version = "~> 3.0"

  vpn_gateway_id      = module.vpc_lab.vgw_id
  customer_gateway_id = aws_customer_gateway.vyos_lab.id

  vpc_id                       = module.vpc_lab.vpc_id
  vpc_subnet_route_table_ids   = module.vpc_lab.private_route_table_ids
  vpc_subnet_route_table_count = length(module.vpc_lab.private_subnets)

  local_ipv4_network_cidr      = "172.31.0.0/16"
  remote_ipv4_network_cidr     = local.vpc_cidr

  vpn_connection_static_routes_only = true
  vpn_connection_static_routes_destinations = ["172.31.0.0/16"]

  tunnel1_preshared_key = ""
  tunnel2_preshared_key = ""

  tags = local.tags
}
