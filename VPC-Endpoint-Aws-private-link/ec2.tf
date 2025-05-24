################################################################
# EC2 en VPC-1 (Subred Privada)
################################################################
module "ec2_vpc1" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.5.0"

  name = "instance-vpc1-private"

  ami                    = data.aws_ami.amazon_linux2.id
  instance_type          = "t2.micro"
  key_name               = "Legion-34"
  monitoring             = true
  vpc_security_group_ids = [module.security_group_vpc1.security_group_id]
  subnet_id              = module.vpc_1.private_subnets[0]

  tags = local.tags
}
