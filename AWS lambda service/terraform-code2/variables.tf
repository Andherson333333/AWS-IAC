# variables.tf

variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
}

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
