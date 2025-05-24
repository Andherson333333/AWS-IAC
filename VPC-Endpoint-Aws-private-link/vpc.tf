################################################################
# VPC-1
################################################################
module "vpc_1" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.17.0"

  name = "vpc-1"
  cidr = local.vpc_cidr_1

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr_1, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr_1, 8, k + 48)]

  enable_nat_gateway   = false
  single_nat_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "subnet_type" = "public"
  }

  private_subnet_tags = {
    "subnet_type" = "private"
  }

  tags = local.tags
}
