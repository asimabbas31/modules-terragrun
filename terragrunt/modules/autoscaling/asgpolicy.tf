resource "aws_autoscaling_policy" "load_policy_up" {
  name = "load_policy_up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.apple.name
}

resource "aws_cloudwatch_metric_alarm" "load_cpu_alarm_up" {
  alarm_name = "load_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "60"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.apple.name
  }

  alarm_description = "This metric monitor API EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.load_policy_up.arn ]
}
