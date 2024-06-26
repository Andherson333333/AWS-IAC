
resource "aws_cloudwatch_metric_alarm" "alarm" {
  alarm_name          = "high_cpu_alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 50
  alarm_description   = "This metric monitors EC2 CPU utilization"
  actions_enabled     = true

  alarm_actions = [
    aws_sns_topic.sns_send.arn
  ]

  dimensions = {
    InstanceId = var.instance_id
  }
}

resource "aws_sns_topic" "sns_send" {
  name = "sns_send"
}

resource "aws_sns_topic_subscription" "example" {
  topic_arn = aws_sns_topic.sns_send.arn
  protocol  = "email"
  endpoint  = var.sns_email
}

resource "aws_cloudwatch_dashboard" "example" {
  dashboard_name = "example_dashboard"

  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/EC2", "CPUUtilization", "InstanceId", "${var.instance_id}" ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "us-east-1",
        "title": "EC2 Instance CPU"
      }
    }
  ]
}
EOF
}
