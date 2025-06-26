locals {
  name   = "vpc-lb"
  region = "us-east-1"

  vpc_cidr_1 = "10.1.0.0/16"
  vpc_cidr_2 = "10.2.0.0/16"
  vpc_cidr_3 = "10.3.0.0/16"

  azs = slice(data.aws_availability_zones.available.names, 0, 2)

  tags = {
    Environment = "staging"
    GithubRepo  = "vpc-tgw-module"
    GithubOrg   = "vpc-tgw-module"
  }
}
