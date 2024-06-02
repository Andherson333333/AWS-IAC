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

