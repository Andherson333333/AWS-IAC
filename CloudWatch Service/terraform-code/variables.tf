variable "instance_id" {
  description = "The ID of the EC2 instance to monitor"
  type        = string
}

variable "sns_email" {
  description = "The email address to subscribe to the SNS topic"
  type        = string
}
