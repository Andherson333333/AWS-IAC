output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.web_server.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the created VPC"
  value       = aws_vpc.web_server.cidr_block
}

output "vpc_tags" {
  description = "Tags of the created VPC"
  value       = aws_vpc.web_server.tags
}

