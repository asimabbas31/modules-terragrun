output "autoscaling_group_apple" {
  value       = aws_autoscaling_group.apple.id
  description = "The arn of the asg group"
  }
