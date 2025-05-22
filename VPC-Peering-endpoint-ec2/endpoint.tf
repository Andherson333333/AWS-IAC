################################################################
# EC2 Instance Connect Endpoint para VPC-1
################################################################
resource "aws_ec2_instance_connect_endpoint" "vpc1" {
  subnet_id          = module.vpc_1.private_subnets[0]
  preserve_client_ip = true

  tags = local.tags
}

################################################################
# EC2 Instance Connect Endpoint para VPC-2
################################################################
resource "aws_ec2_instance_connect_endpoint" "vpc2" {
  subnet_id          = module.vpc_2.private_subnets[0]
  preserve_client_ip = true

  tags = local.tags
}
