################################################################
# Security Group Module
################################################################

module "ec2_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "${local.name}-ec2-sg"
  description = "Security group for EC2 instances - SSH and ICMP access"
  vpc_id      = module.vpc_lab.vpc_id

  ingress_rules       = ["ssh-tcp", "all-icmp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "172.31.0.0/16"
      description = "SSH from on-premises network"
    },
    {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = "172.31.0.0/16"
      description = "ICMP from on-premises network"
    }
  ]

  egress_rules = ["all-all"]

  tags = local.tags
}
