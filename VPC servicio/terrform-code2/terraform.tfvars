# VPC
vpc_cidr_block = "10.0.0.0/16"

vpc_tags = {
  Name        = "VPC"
  Environment = "Production"
}

# Subnet public

public_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24","10.0.5.0/24"]
public_azs = ["us-east-1a", "us-east-1b","us-east-1c"]
public_subnet_tags = {
  Name = "Public Subnet"}

# Subnet private

private_subnet_cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24","10.0.6.0/24"]
private_azs = ["us-east-1a", "us-east-1b","us-east-1c"]
private_subnet_tags = {
  Name = "Private Subnet"
}

