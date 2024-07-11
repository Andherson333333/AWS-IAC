# main.tf

# Create an IAM role for the Lambda function
resource "aws_iam_role" "lambda_role" {
  name = var.lambda_role_name
  
  # Define the trust relationship policy
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Define the Lambda function
resource "aws_lambda_function" "test_lambda" {
  filename         = var.lambda_filename
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = var.lambda_handler
  runtime          = var.lambda_runtime
  source_code_hash = filebase64sha256(var.lambda_filename)
  
  # Environment variables for the Lambda function
  environment {
    variables = var.lambda_environment_variables
  }
}

# Create a zip file for the Lambda function code
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = var.lambda_filename
  source {
    content  = var.lambda_code
    filename = "index.js"
  }
}
