output "sgapp" {
  value       = aws_security_group.sgapp.id
}

output "lbsc" {
  value       = aws_security_group.loadbalancer_app.id
}
