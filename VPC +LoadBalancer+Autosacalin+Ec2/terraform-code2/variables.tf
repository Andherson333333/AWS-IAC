## VPC 
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_tags" {
  description = "Tags for the VPC"
  type        = map(string)
}

## Subnet public

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
}

variable "public_azs" {
  description = "Availability Zones for the public subnets"
  type        = list(string)
}

variable "public_subnet_tags" {
  description = "Tags for the public subnets"
  type        = map(string)
}

## Subnet private

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
}

variable "private_azs" {
  description = "Availability Zones for the private subnets"
  type        = list(string)
}

variable "private_subnet_tags" {
  description = "Tags for the private subnets"
  type        = map(string)
}


## Security group loadbalancer


variable "lb_security_group_name" {
  description = "Nombre del security group para el load balancer"
  type        = string
}

variable "lb_security_group_description" {
  description = "Descripción del security group para el load balancer"
  type        = string
}

variable "exposed_ports" {
  description = "Puertos expuestos por el load balancer"
  type        = list(number)
}

## Load balancer 

variable "lb_name" {
  description = "Nombre del load balancer"
  type        = string
}

variable "lb_internal" {
  description = "Indicador interno para el load balancer"
  type        = bool
  default     = false
}

variable "lb_type" {
  description = "Tipo de load balancer (e.g., application, network)"
  type        = string
  default     = "application"
}

## Target group

variable "target_group_name" {
  description = "Nombre del grupo de destino"
  type        = string
}

variable "target_group_port" {
  description = "Puerto en el que el grupo de destino escucha las solicitudes"
  type        = number
}

variable "target_group_protocol" {
  description = "Protocolo utilizado para la comunicación con el grupo de destino"
  type        = string
}

variable "health_check_path" {
  description = "Ruta para el chequeo de salud"
  type        = string
}

variable "health_check_port" {
  description = "Puerto para el chequeo de salud"
  type        = number
}

variable "health_check_protocol" {
  description = "Protocolo para el chequeo de salud"
  type        = string
}

variable "health_check_timeout" {
  description = "Tiempo de espera en segundos antes de marcar una comprobación como fallida"
  type        = number
}

variable "health_check_interval" {
  description = "Intervalo en segundos entre comprobaciones"
  type        = number
}

variable "health_check_healthy_threshold" {
  description = "Número de comprobaciones saludables consecutivas necesarias para considerar una instancia como saludable"
  type        = number
}

variable "health_check_unhealthy_threshold" {
  description = "Número de comprobaciones no saludables consecutivas necesarias para considerar una instancia como no saludable"
  type        = number
}

variable "tags" {
  description = "Etiquetas que se aplicarán al grupo de destino"
  type        = map(string)
}


# Listener

variable "listener_port" {
  description = "Puerto del listener"
  type        = number
}

variable "listener_protocol" {
  description = "Protocolo del listener"
  type        = string
}

# Ec2 security group

variable "ec2_security_group_name" {
  description = "Nombre del security group para el load balancer"
  type        = string
}

variable "ec2_security_group_description" {
  description = "Descripción del security group para el load balancer"
  type        = string
}


variable "exposed_ports_ec2" {
  description = "Puertos expuestos por el load balancer"
  type        = list(number)
}

# Launch Configuration

variable "ami" {
  description = "ID de la AMI para la Launch Configuration"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia para la Launch Configuration"
  type        = string
}

variable "key_name" {
  description = "Nombre de la key pair para la Launch Configuration"
  type        = string
}
 
# Autoscaling group

variable "asg_name" {
  description = "Nombre del Auto Scaling Group"
  type        = string
}

variable "min_size" {
  description = "Número mínimo de instancias en el ASG"
  type        = number
}

variable "max_size" {
  description = "Número máximo de instancias en el ASG"
  type        = number
}

variable "desired_capacity" {
  description = "Capacidad deseada de instancias en el ASG"
  type        = number
}

variable "scaling_policy_name" {
  description = "Nombre de la política de escalado"
  type        = string
  default     = "scaling-policy"
}

variable "target_cpu_value" {
  description = "Valor objetivo de utilización de CPU para la política de escalado"
  type        = number
}

variable "instance_name" {
  description = "Nombre para las instancias EC2 (se aplicará como tag)"
  type        = string
}
