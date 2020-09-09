output "lt_id" {
  value       = aws_launch_template.payment.id
  description = "The arn of the asg group"
  }

output "lt_version" {
  value       = aws_launch_template.payment.latest_version
  description = "The arn of the asg group"
  }
