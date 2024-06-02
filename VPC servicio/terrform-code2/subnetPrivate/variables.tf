variable "vpc_id" {
  description = "ID of the VPC where the subnets will be created"
  type        = string
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for the subnets"
  type        = list(string)
}

variable "private_azs" {
  description = "Availability Zones for the subnets"
  type        = list(string)
}

variable "private_subnet_tags" {
  description = "Tags for the subnets"
  type        = map(string)
}

