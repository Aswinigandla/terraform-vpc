output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.vcube139.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.vcube139_publicsubnet.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.vcube139_prvsubnet.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.gw.id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public_rt.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private_rt.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.nat.id
}

output "nat_elastic_ip" {
  description = "Public Elastic IP assigned to the NAT Gateway"
  value       = aws_eip.nat_eip.public_ip
}
