################################################################
# VPC Module
################################################################

module "vpc_lab" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.17.0"

  name = "${local.name}-vpc"
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 1)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 101)]

  enable_nat_gateway     = false
  enable_vpn_gateway     = true
  enable_dns_hostnames   = true
  enable_dns_support     = true

  propagate_private_route_tables_vgw = true

  public_subnet_tags = {
    "subnet_type" = "public"
  }

  private_subnet_tags = {
    "subnet_type" = "private"
  }

  tags = local.tags
}
