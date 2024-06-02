resource "aws_vpc" "web_server" {
  cidr_block = var.vpc_cidr_block

  tags = var.vpc_tags
}

