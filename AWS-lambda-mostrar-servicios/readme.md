# AWS Resource Inventory Lambda

## Description
This project uses Terraform to deploy an AWS Lambda function that performs a periodic inventory of resources in your AWS account. The function runs automatically on a configurable schedule, collecting information about various AWS services such as EC2, S3, RDS, and more.

## Features
- Automated inventory of AWS resources
- Complete deployment using Terraform
- Lambda function with read-only permissions
- Flexible scheduling via CloudWatch Events
- Support for multiple AWS services (EC2, S3, Lambda, RDS, DynamoDB, ECS, EKS, ElastiCache, Redshift, SQS)

## Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) (v0.12+)
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- Python 3.12 (for local development and testing)

## Project Structure
```
.
├── main.tf              # Main Terraform configuration
├── variables.tf         # Terraform variable definitions
├── terraform.tfvars     # Variable values
└── README.md            # This file
```

## Configuration and Deployment
1. Modify `terraform.tfvars` if you need to customize any variables.
2. Initialize Terraform:
   ```
   terraform init
   ```
3. Review the planned changes:
   ```
   terraform plan
   ```
4. Apply the configuration:
   ```
   terraform apply
   ```
5. Confirm the creation of resources by typing `yes` when prompted.

Note: Set the time to around 15 seconds

## Usage
Once deployed, the Lambda function will run automatically according to the configured schedule. To verify its operation:
1. Access the AWS console and navigate to CloudWatch > Log groups.
2. Look for the log group `/aws/lambda/resource_inventory_lambda`.
3. Review the log streams to see the results of the executions.

For manual execution, you can use the following AWS CLI command:
```
aws lambda invoke --function-name resource_inventory_lambda output.json
```

## Customization
- Modify the `terraform.tfvars` file to adjust variables according to your needs.
- To change the execution schedule, update the `schedule_expression` variable in `terraform.tfvars`. For example:
  ```hcl
  schedule_expression = "cron(0 12 * * ? *)"  # Run daily at 12 PM UTC
  ```
- Cron expression format:
  - Fields are: minute hour day-of-month month day-of-week year
  - Use `cron(0 1 * * ? *)` to run daily at 1 AM UTC
  - Use `rate(1 day)` to run every 24 hours
  - For more information, consult the [AWS documentation on schedule expressions](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html)

## Terraform Variables

| Name | Description | Type | Default Value |
|------|-------------|------|---------------|
| `lambda_role_name` | Name of the IAM role for Lambda | string | - |
| `lambda_filename` | Name of the Lambda deployment package | string | - |
| `lambda_function_name` | Name of the Lambda function | string | - |
| `lambda_handler` | Lambda function handler | string | - |
| `lambda_runtime` | Lambda function runtime | string | - |
| `lambda_environment_variables` | Environment variables for Lambda | map(string) | {} |
| `lambda_code` | Lambda function code | string | - |
| `schedule_expression` | Schedule expression for CloudWatch Events | string | `"cron(0 1 * * ? *)"` |

## Cleanup
To remove all created resources:
```
terraform destroy
```

![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWS%20lambda%20mostrar%20servicios/imagenes/lambda-1.png)
![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWS%20lambda%20mostrar%20servicios/imagenes/lambda-2.png)
![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWS%20lambda%20mostrar%20servicios/imagenes/lambda-3.png)
