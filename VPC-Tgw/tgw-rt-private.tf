################################################################
# map local vpc
################################################################

locals {
  # Mapa de VPCs con su información
  vpcs_routing = {
    vpc_1 = {
      cidr            = local.vpc_cidr_1
      route_table_ids = module.vpc_1.private_route_table_ids
    }
    vpc_2 = {
      cidr            = local.vpc_cidr_2
      route_table_ids = module.vpc_2.private_route_table_ids
    }
    vpc_3 = {
      cidr            = local.vpc_cidr_3
      route_table_ids = module.vpc_3.private_route_table_ids
    }
  }

  vpc_routes = flatten([
    for vpc_name, vpc_data in local.vpcs_routing : [
      for idx, rt_id in vpc_data.route_table_ids : [
        for other_vpc_name, other_vpc_data in local.vpcs_routing : {
          route_key              = "${vpc_name}_rt${idx}_to_${other_vpc_name}"
          route_table_id         = rt_id
          destination_cidr_block = other_vpc_data.cidr
        }
        if vpc_name != other_vpc_name
      ]
    ]
  ])
}

################################################################
# Propagation of private routes to all VPCs
################################################################

resource "aws_route" "vpc_to_tgw_dynamic" {
  for_each = {
    for route in local.vpc_routes : route.route_key => route
  }

  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.destination_cidr_block
  transit_gateway_id     = module.tgw.ec2_transit_gateway_id
}
