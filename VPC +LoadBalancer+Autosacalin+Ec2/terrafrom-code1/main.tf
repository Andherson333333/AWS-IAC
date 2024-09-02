### Creación VPC ####
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
 
  tags = {
    Name        = "${var.project}-vpc"
    Environment = var.environment
  }
}

#### Creación subnet ####
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]
 
  tags = {
    Name        = "${var.project}-public-subnet-${count.index + 1}"
    Environment = var.environment
  }
}
 
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]
 
  tags = {
    Name        = "${var.project}-private-subnet-${count.index + 1}"
    Environment = var.environment
  }
}

##### Creación IGW ####
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
 
  tags = {
    Name        = "${var.project}-igw"
    Environment = var.environment
  }
}

##### Creación tabla public ####
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
 
  tags = {
    Name        = "${var.project}-public-route-table"
    Environment = var.environment
  }
}

##### Creación tabla private-1 ####
resource "aws_route_table" "private-rt1" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name        = "${var.project}-private-route-table-az1"
    Environment = var.environment
  }
}

##### Creación tabla private-2 ####
resource "aws_route_table" "private-rt2" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name        = "${var.project}-private-route-table-az2"
    Environment = var.environment
  }
}

##### Asociación de subnet a tablas de rutas por tag ######

resource "aws_route_table_association" "private_subnet_asso" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = count.index == 0 ? aws_route_table.private-rt1.id : aws_route_table.private-rt2.id
}

resource "aws_route_table_association" "public_subnet_asso" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public-rt.id
}

########### Creación load balancer y sus componentes ###########

#### Creación del security group para load balancer group ####

resource "aws_security_group" "lb-http-connection" {
  name        = "${var.project}-lb-http-connection"
  description = "Load balancer HTTP connection"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name        = "${var.project}-lb-sg"
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "lb_exposed_ports" {
  count             = length(var.exposed_ports)
  type              = "ingress"
  description       = "Ingress for exposed ports for load balancer"
  from_port         = var.exposed_ports[count.index]
  to_port           = var.exposed_ports[count.index]
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb-http-connection.id
}

resource "aws_security_group_rule" "lb_allow_all" {
  type              = "egress"
  description       = "Allow all outbound traffic for load balancer"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb-http-connection.id
}

#### Creación loadbalancer #####

resource "aws_lb" "load-balancer" {
  name               = "${var.project}-load-balancer"
  internal           = false
  load_balancer_type = "application"
  
  security_groups = [aws_security_group.lb-http-connection.id]
  subnets         = aws_subnet.public_subnets[*].id

  tags = {
    Name        = "${var.project}-alb"
    Environment = var.environment
  }
}

##### Creación del Target group ######

resource "aws_lb_target_group" "target_group" {
  name     = "${var.project}-target-group"
  port     = var.exposed_ports_ec2[0]
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    port                = var.exposed_ports_ec2[0]
    protocol            = "HTTP"
    timeout             = 5
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "${var.project}-tg"
    Environment = var.environment
  }
}

#### Creación de listener ####

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.load-balancer.arn
  port              = var.exposed_ports[0]
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

#### Creación security group para las instancias #####

resource "aws_security_group" "instancia_ec2" {
  name        = "${var.project}-ec2-instance"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name        = "${var.project}-ec2-sg"
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "ec2_exposed_ports" {
  count                    = length(var.exposed_ports_ec2)
  type                     = "ingress"
  description              = "Ingress for exposed ports for EC2 instances"
  from_port                = var.exposed_ports_ec2[count.index]
  to_port                  = var.exposed_ports_ec2[count.index]
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb-http-connection.id
  security_group_id        = aws_security_group.instancia_ec2.id
}

resource "aws_security_group_rule" "ec2_allow_all" {
  type              = "egress"
  description       = "Allow all outbound traffic for EC2 instances"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.instancia_ec2.id
}

#### Crear Launch Configuration ####

resource "aws_launch_configuration" "ami_config" {
  name_prefix   = "${var.project}-lc-"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = "legion33"
  security_groups = [aws_security_group.instancia_ec2.id]

  lifecycle {
    create_before_destroy = true
  }
}

######### Crear autoscaling group #############

resource "aws_autoscaling_group" "ec2_asg" {
  name                 = "${var.project}-asg"
  launch_configuration = aws_launch_configuration.ami_config.name
  min_size             = 1
  max_size             = 4
  desired_capacity     = 2

  vpc_zone_identifier = aws_subnet.private_subnets[*].id

  tag {
    key                 = "Name"
    value               = "${var.project}-asg-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}

#### Asociación entre autoscaling y balanciador de carga por el target group #####

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.ec2_asg.name
  lb_target_group_arn    = aws_lb_target_group.target_group.arn
}

##### Recurso para la política de escalado automático (ejemplo basado en métrica de CPU) ####

resource "aws_autoscaling_policy" "scaling_policy" {
  name                   = "${var.project}-scaling-policy"
  autoscaling_group_name = aws_autoscaling_group.ec2_asg.name
  policy_type            = "TargetTrackingScaling"
  
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50
  }
}

#### Creación del Elastic IP #####

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name        = "${var.project}-nat-eip"
    Environment = var.environment
  }
}

#### Creación del NAT Gateway #####

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name        = "${var.project}-nat-gateway"
    Environment = var.environment
  }
}

#### Asociación de subnet privada con NAT Gateway #####

resource "aws_route" "nat_gateway_route" {
  route_table_id         = aws_route_table.private-rt1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}
