# VPC ID
output "vpc_id" {
  value = aws_vpc.this.id
}

# Subnet IDs in all AZs 
output "subnet_ids" {
  value = flatten([aws_subnet.public[*].id, aws_subnet.private[*].id])
}

# Subnet IDs in all AZs 
output "private_subnet_ids" {
  value = flatten([aws_subnet.private[*].id])
}


# Internet Gateway ID
output "internet_gateway" {
  value = aws_internet_gateway.this.id
}