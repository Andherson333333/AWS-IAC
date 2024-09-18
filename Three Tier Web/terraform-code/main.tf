##############################################################################
# Provider
###############################################################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  alias  = "virginia"
  region = local.region
}

###############################################################################
# local.tf
###############################################################################
locals {
  name   = "project-T3"
  region = "us-east-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)

  tags = {
    Environment = "staging"
    GithubOrg   = "terraform-aws-modules"
  }

  # Database configuration
  db_name     = "webappdb"
  db_username = "admin"
  db_password = "admin123"  # Nota: En un entorno real, usa gestión de secretos
}

###############################################################################
# data.tf
###############################################################################
data "aws_availability_zones" "available" {}

###############################################################################
# vpc
###############################################################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name = local.name
  cidr = local.vpc_cidr

  azs              = local.azs
  private_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]
  database_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 52)]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "subnet_type" = "public"
  }

  private_subnet_tags = {
    "subnet_type" = "private"
  }

  database_subnet_tags = {
    "subnet_type" = "database"
  }

  tags = local.tags
}

###############################################################################
# Security Groups
###############################################################################
module "public_alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "${local.name}-public-alb-sg"
  description = "Security group for internet facing ALB"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  egress_rules        = ["all-all"]

  tags = local.tags
}

module "web_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "${local.name}-web-sg"
  description = "Security group for web tier"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.public_alb_sg.security_group_id
    }
  ]
  egress_rules = ["all-all"]

  tags = local.tags
}

module "internal_alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "${local.name}-internal-alb-sg"
  description = "Security group for internal ALB"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.web_sg.security_group_id
    }
  ]
  egress_rules = ["all-all"]

  tags = local.tags
}

module "app_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "${local.name}-app-sg"
  description = "Security group for app tier"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 4000
      to_port                  = 4000
      protocol                 = "tcp"
      source_security_group_id = module.internal_alb_sg.security_group_id
    }
  ]
  egress_rules = ["all-all"]

  tags = local.tags
}

module "db_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "${local.name}-db-sg"
  description = "Security group for database"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.app_sg.security_group_id
    }
  ]
  egress_rules = ["all-all"]

  tags = local.tags
}

###############################################################################
# Aurora MySQL Database Cluster
###############################################################################
module "aurora_mysql" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "9.9.1"

  name           = lower(replace("${local.name}-aurora-mysql", "-", ""))
  engine         = "aurora-mysql"
  engine_version = "8.0.mysql_aurora.3.05.2"
  instance_class = "db.t3.medium"

  instances = {
    1 = {}
    2 = {}
  }

  vpc_id               = module.vpc.vpc_id
  db_subnet_group_name = module.vpc.database_subnet_group_name

  create_security_group = false
  vpc_security_group_ids = [module.db_sg.security_group_id]

  availability_zones = module.vpc.azs

  database_name          = local.db_name
  master_username        = local.db_username
  master_password        = local.db_password

  port = 3306

  storage_encrypted   = true
  apply_immediately   = true
  monitoring_interval = 60

  backup_retention_period = 7
  preferred_backup_window = "02:00-03:00"

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  db_parameter_group_name         = aws_db_parameter_group.example.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.example.id

  skip_final_snapshot = true
  deletion_protection = false

  tags = local.tags
}

resource "aws_db_parameter_group" "example" {
  name        = "${lower(replace(local.name, "-", ""))}-aurora-db-57-pg"
  family      = "aurora-mysql8.0"
  description = "${local.name} aurora db 5.7 parameter group"
  tags        = local.tags
}

resource "aws_rds_cluster_parameter_group" "example" {
  name        = "${lower(replace(local.name, "-", ""))}-aurora-db-57-pg"
  family      = "aurora-mysql8.0"
  description = "${local.name} aurora db 5.7 parameter group"
  tags        = local.tags
}
###############################################################################
# Aurora MySQL Database Cluster Output
###############################################################################
output "db_cluster_endpoint" {
  description = "The cluster endpoint"
  value       = module.aurora_mysql.cluster_endpoint
}

output "db_cluster_reader_endpoint" {
  description = "The cluster reader endpoint"
  value       = module.aurora_mysql.cluster_reader_endpoint
}
###############################################################################
# LoadBalancer interno
###############################################################################
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.11.0"

  name               = "${local.name}-internal-alb"
  load_balancer_type = "application"
  internal           = true

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.private_subnets

  security_groups = [module.internal_alb_sg.security_group_id]

  target_groups = {
    app_tg = {
      name_prefix          = "app-"
      backend_protocol     = "HTTP"
      port                 = 4000
      target_type          = "instance"
      deregistration_delay = 300
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/health"
        port                = 4000
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
      }
        create_attachment   = false
    }
  }

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "app_tg"
      }
    }
  }

  tags = local.tags
}

###############################################################################
# Launch Template
###############################################################################
resource "aws_launch_template" "this" {
  name_prefix   = "${local.name}-lt-"
  image_id      = "ami-0b7a776526426b44d"
  instance_type = "t2.micro"

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [module.app_sg.security_group_id]
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.this.name
  }

  monitoring {
    enabled = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(local.tags, {
      Name = "${local.name}-asg-instance"
    })
  }
}

###############################################################################
# Auto Scaling Group
###############################################################################
resource "aws_autoscaling_group" "this" {
  name                = "${local.name}-asg"
  vpc_zone_identifier = module.vpc.private_subnets
  target_group_arns   = [module.alb.target_groups["app_tg"].arn]
  health_check_type   = "EC2"
  min_size            = 1
  max_size            = 4
  desired_capacity    = 2

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${local.name}-asg-instance"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = local.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

###############################################################################
# IAM Role and Instance Profile
###############################################################################
resource "aws_iam_role" "this" {
  name               = "${local.name}-asg-role"
  path               = "/ec2/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(local.tags, {
    CustomIamRole = "Yes"
  })
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.this.name
}

resource "aws_iam_instance_profile" "this" {
  name = "${local.name}-asg-instance-profile"
  role = aws_iam_role.this.name
}

###############################################################################
# Outputs Autoscaling group and template
###############################################################################
output "asg_name" {
  description = "The name of the Auto Scaling Group"
  value       = aws_autoscaling_group.this.name
}

output "launch_template_id" {
  description = "The ID of the launch template"
  value       = aws_launch_template.this.id
}
###############################################################################
# LoadBalancer externo
###############################################################################
module "external_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.11.0"

  name               = "${local.name}-external-alb"
  load_balancer_type = "application"
  internal           = false

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  security_groups = [module.public_alb_sg.security_group_id]

  target_groups = {
    web_tg = {
      name_prefix      = "web-"
      backend_protocol = "HTTP"
      port             = 80
      target_type      = "instance"
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/health"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
      }
    create_attachment = false
    }
  }

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "web_tg"
      }
    }
  }

  tags = local.tags
}
###############################################################################
# Launch Template web externo
###############################################################################
resource "aws_launch_template" "web" {
  name_prefix   = "${local.name}-web-lt-"
  image_id      = "ami-09662151797e527e9"  
  instance_type = "t2.micro"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [module.web_sg.security_group_id]
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.web.name
  }

  monitoring {
    enabled = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(local.tags, {
      Name = "${local.name}-web-instance"
    })
  }
}
###############################################################################
# Autoscaling group externo
###############################################################################
resource "aws_autoscaling_group" "web" {
  name                = "${local.name}-web-asg"
  vpc_zone_identifier = module.vpc.public_subnets
  target_group_arns   = [module.external_alb.target_groups["web_tg"].arn]
  health_check_type   = "EC2"
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${local.name}-web-instance"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = local.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
###############################################################################
# IAM Role and Instance Profile web externo
###############################################################################
resource "aws_iam_role" "web" {
  name               = "${local.name}-web-role"
  path               = "/ec2/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(local.tags, {
    CustomIamRole = "Yes"
  })
}

resource "aws_iam_role_policy_attachment" "web_ssm_managed_instance_core" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.web.name
}

resource "aws_iam_instance_profile" "web" {
  name = "${local.name}-web-instance-profile"
  role = aws_iam_role.web.name
}

###############################################################################
# IAM Role and Instance Profile web externo
###############################################################################
