###############################################################
# AWS Site-to-Site VPN Infrastructure
################################################################

locals {
  name   = "vpc-connect"
  region = "us-east-1"

  vpc_cidr = "10.1.0.0/16"
  azs = slice(data.aws_availability_zones.available.names, 0, 2)

  tags = {
    Environment = "lab"
    Project     = "networking-lab"
    Owner       = "vpn-connect"
    CreatedBy   = "terraform"
  }
}
