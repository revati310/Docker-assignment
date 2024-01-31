output "subnet_block" {
  value = aws_subnet.public_subnet.id
}

output "vpc_block" {
  value = aws_vpc.main.id
}