################################################################
# EC2 Instance Module
################################################################

module "ec2_test_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.5.0"

  name = "${local.name}-test-server"

  ami           = data.aws_ami.amazon_linux2.id
  instance_type = "t2.micro"
  key_name      = "XXXXX"  # UPDATE: Replace with your key pair name
  monitoring    = true

  vpc_security_group_ids = [module.ec2_security_group.security_group_id]
  subnet_id              = module.vpc_lab.private_subnets[0]

  tags = local.tags
}
