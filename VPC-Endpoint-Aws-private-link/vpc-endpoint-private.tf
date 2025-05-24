################################################################
# VPC Endpoints Module - S3 + SSM
################################################################
module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.17.0"

  vpc_id = module.vpc_1.vpc_id

  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = module.vpc_1.private_route_table_ids

      tags = {
        Name = "s3-gateway-endpoint"
      }
    }

# Private link
    ssm = {
      service             = "ssm"
      service_type        = "Interface"
      subnet_ids          = [module.vpc_1.private_subnets[0]] 
      security_group_ids  = [module.security_group_vpc1.security_group_id]
      private_dns_enabled = true

      tags = {
        Name = "ssm-interface-endpoint"
      }
    }
  }

  tags = local.tags
}
