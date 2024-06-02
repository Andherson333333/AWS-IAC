output "private_subnet_ids" {
  description = "IDs of the created private subnets"
  value       = aws_subnet.private_subnets[*].id
}

output "private_subnet_cidr_blocks" {
  description = "CIDR blocks of the created private subnets"
  value       = aws_subnet.private_subnets[*].cidr_block
}

output "private_subnet_azs" {
  description = "Availability Zones of the created private subnets"
  value       = aws_subnet.private_subnets[*].availability_zone
}

output "private_subnet_tags" {
  description = "Tags of the created private subnets"
  value       = aws_subnet.private_subnets[*].tags
}


