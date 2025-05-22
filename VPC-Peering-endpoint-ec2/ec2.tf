################################################################
# EC2 en VPC-1 (Subred Privada)
################################################################
module "ec2_vpc1" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.5.0"

  name = "instance-vpc1-private"

  ami                    = data.aws_ami.amazon_linux2.id
  instance_type          = "t2.micro"
  key_name               = "your-key-pair-name"  # Replace with your actual key pair name
  monitoring             = true
  vpc_security_group_ids = [module.security_group_vpc1.security_group_id]
  subnet_id              = module.vpc_1.private_subnets[0]

  tags = local.tags
}

################################################################
# EC2 en VPC-2 (Subred Privada)
################################################################
module "ec2_vpc2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.5.0"

  name = "instance-vpc2-private"

  ami                    = data.aws_ami.amazon_linux2.id
  instance_type          = "t2.micro"
  key_name               = "your-key-pair-name"  # Replace with your actual key pair name
  monitoring             = true
  vpc_security_group_ids = [module.security_group_vpc2.security_group_id]
  subnet_id              = module.vpc_2.private_subnets[0]

  tags = local.tags
}
