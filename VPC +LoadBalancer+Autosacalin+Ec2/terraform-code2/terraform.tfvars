# VPC
vpc_cidr_block = "10.0.0.0/16"

vpc_tags = {
  Name        = "VPC"
  Environment = "Production"
}

# Subnet public

public_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24","10.0.5.0/24"]
public_azs = ["us-east-1a", "us-east-1b","us-east-1c"]
public_subnet_tags = {
  Name = "Public Subnet"}

# Subnet private

private_subnet_cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24","10.0.6.0/24"]
private_azs = ["us-east-1a", "us-east-1b","us-east-1c"]
private_subnet_tags = {
  Name = "Private Subnet"
}

# Security group

lb_security_group_description = "Security Group para mi Load Balancer"
lb_security_group_name = "mi-lb-security-group"
exposed_ports = [80, 443]

# Loadbalancer

lb_name                       = "MyLoadBalancer"
lb_internal                   = false
lb_type                       = "application"
lb_security_group_id	      = module.security_group_lb.securityGroupLB_id

# Target group

target_group_name             = "MyTargetGroup"
target_group_port             = 3000
target_group_protocol         = "HTTP"
health_check_path             = "/health"
health_check_port             = 3000
health_check_protocol         = "HTTP"
health_check_timeout          = 10
health_check_interval         = 30
health_check_healthy_threshold = 3
health_check_unhealthy_threshold = 2
tags = {
  Name = "EC2 target group"
}

# Listener

listener_port     = 80
listener_protocol = "HTTP"

# Ec2 security group

ec2_security_group_description = "Security Group para mi Load Balancer"
ec2_security_group_name = "mi-ec2-security-group"
exposed_ports_ec2 = [3000]

# Launch Configuration

ami = "ami-04d92be90be5e055a"
instance_type = "t2.micro"
key_name = "legion33"


# Autoscaling group
asg_name = "mi-auto-scaling-group"
min_size         = 1
max_size         = 6
desired_capacity = 3
target_cpu_value = 50
instance_name = "mi-instancia-asg"
