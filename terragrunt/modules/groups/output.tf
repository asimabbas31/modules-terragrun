

output "lbsc" {
  value       = aws_security_group.loadbalancer_app.id
}

output "rmqsg" {
  value       = aws_security_group.rmq.id
}
