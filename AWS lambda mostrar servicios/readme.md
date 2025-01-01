# AWS Resource Inventory Lambda

## Description
This project uses Terraform to deploy an AWS Lambda function that periodically inventories resources in your AWS account. The function runs automatically on a configurable schedule, gathering information about various AWS services such as EC2, S3, RDS, and more.

## Features
- Automated inventory of AWS resources
- Full deployment using Terraform
- Read-only Lambda function
- Flexible scheduling via CloudWatch Events
- Support for multiple AWS services (EC2, S3, Lambda, RDS, DynamoDB, ECS, EKS, ElastiCache, Redshift, SQS)

## Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) (v0.12+)
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- Python 3.12 (for local development and testing)

## Project Structure
```
.
├── main.tf              # Configuración principal de Terraform
├── variables.tf         # Definición de variables de Terraform
├── terraform.tfvars     # Valores de las variables
└── README.md            # Este archivo
```

Setup and Deployment

1. Update `terraform.tfvars` to customize any variables if needed.

2. Initialize Terraform:
   ```
   terraform init
   ```
3.  Review the planned changes:
   ```
   terraform plan
   ```

4. Apply the configuration:
   ```
   terraform apply
   ```
5. Confirm resource creation by typing `yes` when prompted.

## Usage

Once deployed, the Lambda function will execute automatically based on the configured schedule. To verify its functionality:

1. Access the AWS Console and navigate to CloudWatch > Log groups.
2. Find the log group `/aws/lambda/resource_inventory_lambda`.
3. Check the log streams for execution results.

To trigger a manual execution, use the following AWS CLI command:
```
aws lambda invoke --function-name resource_inventory_lambda output.json
```
## Customization
- Update the `terraform.tfvars` file to adjust variables as needed.
- To modify the execution schedule, update the `schedule_expression` variable in `terraform.tfvars`. For example:
  ```hcl
  schedule_expression = "cron(0 12 * * ? *)"  # Run daily at 12 PM UTC
  
## Terraform Variables
| Name                     | Description                             | Type         | Default Value       |
|--------------------------|-----------------------------------------|--------------|---------------------|
| `lambda_role_name`       | IAM role name for Lambda               | string       | -                   |
| `lambda_filename`        | Lambda deployment file name            | string       | -                   |
| `lambda_function_name`   | Lambda function name                   | string       | -                   |
| `lambda_handler`         | Lambda function handler                | string       | -                   |
| `lambda_runtime`         | Lambda function runtime                | string       | -                   |
| `lambda_environment_variables` | Environment variables for Lambda | map(string)  | {}                  |
| `lambda_code`            | Lambda function code                   | string       | -                   |
| `schedule_expression`    | CloudWatch Events schedule expression  | string       | `"cron(0 1 * * ? *)"` |

## Cleanup

```
terraform destroy
```

![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWS%20lambda%20mostrar%20servicios/imagenes/lambda-1.png)

![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWS%20lambda%20mostrar%20servicios/imagenes/lambda-2.png)

![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWS%20lambda%20mostrar%20servicios/imagenes/lambda-3.png)
