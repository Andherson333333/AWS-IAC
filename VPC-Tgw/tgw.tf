module "tgw" {
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "~> 2.12"

  name        = "tgw-full-mesh"
  description = "Transit Gateway para full mesh entre 4 VPCs"

  # Configuration for automatic Full Mesh
  enable_auto_accept_shared_attachments  = false
  share_tgw                              = false
  enable_default_route_table_association = true
  enable_default_route_table_propagation = true

  enable_dns_support                     = true
  enable_vpn_ecmp_support                = true

  # VPC Attachments
  vpc_attachments = {
    vpc_1 = {
      vpc_id     = module.vpc_1.vpc_id
      subnet_ids = module.vpc_1.private_subnets

      dns_support  = true
      ipv6_support = false

      # Full mesh por defecto
      transit_gateway_default_route_table_association = true
      transit_gateway_default_route_table_propagation = true

      tags = {
        Name = "tgw-attach-vpc-1"
      }
    }

    vpc_2 = {
      vpc_id     = module.vpc_2.vpc_id
      subnet_ids = module.vpc_2.private_subnets

      dns_support  = true
      ipv6_support = false

      transit_gateway_default_route_table_association = true
      transit_gateway_default_route_table_propagation = true

      tags = {
        Name = "tgw-attach-vpc-2"
      }
    }

    vpc_3 = {
      vpc_id     = module.vpc_3.vpc_id
      subnet_ids = module.vpc_3.private_subnets

      dns_support  = true
      ipv6_support = false

      transit_gateway_default_route_table_association = true
      transit_gateway_default_route_table_propagation = true

      tags = {
        Name = "tgw-attach-vpc-3"
      }
    }
  }

  depends_on = [module.vpc_1,module.vpc_2,module.vpc_3]

  tags = local.tags
}
