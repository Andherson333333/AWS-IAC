module "vpc" {
  source          = "/home/ubuntu/terraform/module/vpc" # cambiar la ruta de archivos
  vpc_cidr_block = var.vpc_cidr_block
  vpc_tags       = var.vpc_tags
}

module "public_subnets" {
  source            = "/home/ubuntu/terraform/module/subnetPublic" # cambiar la ruta de archivos
  vpc_id            = module.vpc.vpc_id
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  public_azs        = var.public_azs
  public_subnet_tags= var.public_subnet_tags
}

module "private_subnets" {
  source            = "/home/ubuntu/terraform/module/subnetPrivate" # cambiar la ruta de archivos
  vpc_id            = module.vpc.vpc_id
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  private_azs        = var.private_azs
  private_subnet_tags= var.private_subnet_tags
}

