################################################################
# Módulo Security Group para VPC-1
################################################################
module "security_group_vpc1" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "ec2-sg-vpc1"
  description = "Security group para EC2 en VPC-1 con acceso SSH e ICMP"
  vpc_id      = module.vpc_1.vpc_id

  # Usar reglas predefinidas para SSH
  ingress_rules       = ["ssh-tcp", "all-icmp","https"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules = ["all-all"]

  tags = local.tags
}
