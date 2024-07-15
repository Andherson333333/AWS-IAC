
# Create an IAM role for the Lambda function
resource "aws_iam_role" "lambda_role" {
  name = var.lambda_role_name
  description = "IAM role for the Lambda function with read-only access"
  
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

# Attach AWS managed ReadOnlyAccess policy to the Lambda role
resource "aws_iam_role_policy_attachment" "lambda_read_only_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Attach Lambda basic execution role policy
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Define the Lambda function
resource "aws_lambda_function" "resource_inventory_lambda" {
  filename         = var.lambda_filename
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = var.lambda_handler
  runtime          = var.lambda_runtime
  source_code_hash = filebase64sha256(var.lambda_filename)
  
  description = "Lambda function to inventory AWS resources periodically"

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
    filename = "ShowService.py"
  }
}

# CloudWatch Event Rule for periodic execution
resource "aws_cloudwatch_event_rule" "periodic_inventory" {
  name                = "periodic-resource-inventory"
  description         = "Triggers resource inventory Lambda function periodically"
  schedule_expression = var.schedule_expression
}

# CloudWatch Event Target linking the rule to the Lambda function
resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule      = aws_cloudwatch_event_rule.periodic_inventory.name
  target_id = "InvokeResourceInventoryLambda"
  arn       = aws_lambda_function.resource_inventory_lambda.arn
}

# Lambda permission to allow CloudWatch to invoke the function
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.resource_inventory_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.periodic_inventory.arn
}
