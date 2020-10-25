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
  actions_enabled     = true
  treat_missing_data  = "breaching"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.apple.name
  }

  alarm_description = "This metric monitor API EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.load_policy_up.arn ]


 tags = {
    Name        = "API overall CPU usage"
    source      = "terraform"
    project     = "API"
    env = var.env
  }
}


resource "aws_autoscaling_policy" "load_policy_down" {
  name = "web_policy_down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.apple.name
}

resource "aws_cloudwatch_metric_alarm" "load_cpu_alarm_down" {
  alarm_name = "load_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "20"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.apple.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.load_policy_down.arn ]


tags = {
    Name        = "API Down CPU usage"
    source      = "terraform"
    project     = "API"
    env = var.env
  }
}
