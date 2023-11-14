output "vpc_ids" {
  value = aws_vpc.Main.id
}

output "subnet_private" {
  value = aws_subnet.private.*.id
}

output "subnet_public" {
  value = aws_subnet.public.*.id
}