module "vpc" {
  source          = "/home/ubuntu/terraform/module/vpc"
  vpc_cidr_block  = var.vpc_cidr_block
  vpc_tags        = var.vpc_tags
}

module "public_subnets" {
  source                    = "/home/ubuntu/terraform/module/subnetPublic"
  vpc_id                    = module.vpc.vpc_id
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  public_azs                = var.public_azs
  public_subnet_tags        = var.public_subnet_tags
}

module "private_subnets" {
  source                     = "/home/ubuntu/terraform/module/subnetPrivate"
  vpc_id                     = module.vpc.vpc_id
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  private_azs                = var.private_azs
  private_subnet_tags        = var.private_subnet_tags
}

module "security_group_lb" {
  source                        = "/home/ubuntu/terraform/module/securityLB"
  lb_security_group_name        = var.lb_security_group_name
  lb_security_group_description = var.lb_security_group_description
  vpc_id                        = module.vpc.vpc_id
  exposed_ports                 = var.exposed_ports
}

module "load_balancer" {
  source                           = "/home/ubuntu/terraform/module/load-balancer"
  lb_name                          = var.lb_name
  lb_internal                      = var.lb_internal
  lb_type                          = var.lb_type
  securityGroupLB_id               = module.security_group_lb.securityGroupLB_id
  lb_subnets                       = module.public_subnets.public_subnet_ids_list
  vpc_id                           = module.vpc.vpc_id 
# Targe gropup
  target_group_name                = var.target_group_name
  target_group_port                = var.target_group_port
  target_group_protocol            = var.target_group_protocol
  health_check_path                = var.health_check_path
  health_check_port                = var.health_check_port
  health_check_protocol            = var.health_check_protocol
  health_check_timeout             = var.health_check_timeout
  health_check_interval            = var.health_check_interval
  health_check_healthy_threshold   = var.health_check_healthy_threshold
  health_check_unhealthy_threshold = var.health_check_unhealthy_threshold
  tags                             = var.tags
#Listener
  listener_port                    = var.listener_port
  listener_protocol                = var.listener_protocol
}

module "security_group_ec2" {
  source                         = "/home/ubuntu/terraform/module/securityEC2"
  ec2_security_group_name        = var.ec2_security_group_name
  ec2_security_group_description = var.ec2_security_group_description
  vpc_id                         = module.vpc.vpc_id
  exposed_ports_ec2              = var.exposed_ports_ec2
  securityGroupLB_id	         = module.security_group_lb.securityGroupLB_id
# Lauch configuation
  ami                            = var.ami
  instance_type                  = var.instance_type
  key_name                       = var.key_name
}

module "autoscaling_group" {
  source                    = "/home/ubuntu/terraform/module/autoscaling"
  asg_name                  = var.asg_name
  launch_configuration_name = module.security_group_ec2.launch_configuration_name
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  subnet_ids                = module.private_subnets.private_subnet_ids
  target_group_arn          = module.load_balancer.target_group_arn
  scaling_policy_name       = var.scaling_policy_name
  target_cpu_value          = var.target_cpu_value
  instance_name             = var.instance_name
}
