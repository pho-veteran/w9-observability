output "instance_id" {
  value = aws_instance.monitoring_ec2.id
}

output "instance_public_ip" {
  value = aws_instance.monitoring_ec2.public_ip
}

output "sns_topic_arn" {
  value = aws_sns_topic.cpu_alarm_topic.arn
}

output "cloudwatch_alarm_name" {
  value = aws_cloudwatch_metric_alarm.cpu_high.alarm_name
}
