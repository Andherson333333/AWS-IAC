################################################################
# local
################################################################
locals {
  name   = "vpc-peering"
  region = "us-east-1"

  vpc_cidr_1 = "10.1.0.0/16"
  vpc_cidr_2 = "10.2.0.0/16"

  azs = slice(data.aws_availability_zones.available.names, 0, 2)

  tags = {
    Environment = "staging"
    GithubRepo  = "vpc-peering"
    GithubOrg   = "vpc-peering-module"
    Terraform   = "true"
  }
}
