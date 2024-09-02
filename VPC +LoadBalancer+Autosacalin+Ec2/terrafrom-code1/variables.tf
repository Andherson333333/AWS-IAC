# variables.tf

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
}

variable "exposed_ports" {
  type        = list(number)
  description = "List of exposed ports for the load balancer"
}

variable "exposed_ports_ec2" {
  type        = list(number)
  description = "List of exposed ports for EC2 instances"
}

variable "ami" {
  type        = string
  description = "AMI ID for EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "region" {
  type        = string
  description = "AWS region to deploy resources"
}

variable "project" {
  type        = string
  description = "Project name for tagging"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, prod, staging)"
}
