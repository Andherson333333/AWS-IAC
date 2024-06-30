output "public_subnet_ids" {
  description = "IDs of the created public subnets"
  value       = aws_subnet.public_subnets[*].id
}

output "public_subnet_cidr_blocks" {
  description = "CIDR blocks of the created public subnets"
  value       = aws_subnet.public_subnets[*].cidr_block
}

output "public_subnet_azs" {
  description = "Availability Zones of the created public subnets"
  value       = aws_subnet.public_subnets[*].availability_zone
}

output "public_subnet_tags" {
  description = "Tags of the created public subnets"
  value       = aws_subnet.public_subnets[*].tags
}

output "public_subnet_ids_list" {
  description = "List of IDs of the created public subnets"
  value       = [for subnet in aws_subnet.public_subnets : subnet.id]
}
