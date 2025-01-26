output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = [aws_subnet.public_a.id, aws_subnet.public_c.id]
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.main.dns_name
}
