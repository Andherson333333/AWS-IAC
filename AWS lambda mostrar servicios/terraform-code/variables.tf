
variable "lambda_role_name" {
  description = "Name of the IAM role for Lambda"
  type        = string
}

variable "lambda_filename" {
  description = "The name of the Lambda deployment package"
  type        = string
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "lambda_handler" {
  description = "The Lambda function handler"
  type        = string
}

variable "lambda_runtime" {
  description = "The Lambda function runtime"
  type        = string
}

variable "lambda_environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "lambda_code" {
  description = "The Lambda function code"
  type        = string
}

variable "schedule_expression" {
  description = "CloudWatch Events schedule expression for Lambda function execution"
  type        = string
  default     = "cron(0 1 * * ? *)"  # Default to 1 AM UTC daily
}
