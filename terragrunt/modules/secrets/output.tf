output "instance_policy" {
  value       = aws_iam_instance_profile.payment_backend.arn
  description = "The arn of the policy group"
  }
