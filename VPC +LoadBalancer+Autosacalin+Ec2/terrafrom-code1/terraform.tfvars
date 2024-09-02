# terraform.tfvars

public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
azs                  = ["us-east-1a", "us-east-1b"]
exposed_ports        = [80]
exposed_ports_ec2    = [3000]
ami                  = "ami-04e5276ebb8451442"
instance_type        = "t2.micro"
vpc_cidr             = "10.0.0.0/16"
region               = "us-east-1"
project              = "my-terraform-project"
environment          = "development"
