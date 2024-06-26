output "alarm_arn" {
  description = "ARN  CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.alarm.arn
}

output "sns_topic_arn" {
  description = "Arn Topic"
  value       = aws_sns_topic.sns_send.arn
}

output "dashboard_name" {
  description = "Nombre dashboard"
  value       = aws_cloudwatch_dashboard.example.dashboard_name
}
