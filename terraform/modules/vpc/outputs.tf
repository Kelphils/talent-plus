output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "The ID of the VPC"
}

output "public_subnets" {
  value       = aws_subnet.public_subnet.*.id
  description = "The IDs of the public subnets"
}

output "private_subnets" {
  value       = aws_subnet.private_subnet.*.id
  description = "The IDs of the private subnets"
}

output "vpc_cidr_block" {
  value       = aws_vpc.vpc.cidr_block
  description = "The CIDR block of the VPC"
}
