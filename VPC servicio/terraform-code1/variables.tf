variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "exposed_ports" {
  type        = list(number)
  description = "List of exposed ports for the load balancer"
  default     = [80]
}

variable "exposed_ports_ec2" {
  type        = list(number)
  description = "List of exposed ports for EC2 instances"
  default     = [3000]
}

