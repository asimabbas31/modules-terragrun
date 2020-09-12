output "target_group_apple" {
  value       = aws_lb_target_group.apple.arn
  description = "The arn of the target group"
}

output "dnsname" {
  value       = aws_lb.payment_lb.dns_name
  description = "The arn of the target group"
}
