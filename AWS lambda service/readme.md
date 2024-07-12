# Lambda Deployment Project
This project demonstrates how to deploy an AWS Lambda function using both Terraform and CloudFormation. It includes examples of serverless deployment and basic Lambda function creation.

## Table of Contents
- [Overview](#overview)
- [Serverless and Lambda](#serverless-and-lambda)
- [Project Structure](#project-structure)
- [Deployment with Terraform](#deployment-with-terraform)
- [Deployment with CloudFormation](#deployment-with-cloudformation)
- [Getting Started](#getting-started)

## Overview
This repository contains code and configuration files to deploy a simple AWS Lambda function using two different Infrastructure as Code (IaC) tools: Terraform and CloudFormation.

## Serverless and Lambda
### What is Serverless?
Serverless is a cloud execution model where the cloud provider automatically manages the infrastructure needed to run the code. You don't need to create, manage, or scale servers, EC2 instances, or containers. Instead, the code runs in response to specific events and only for the duration of the execution, allowing for efficient management and automatic scaling.

### What is Lambda?
AWS Lambda is a serverless compute service that runs your code in response to events and automatically manages the underlying compute resources for you. You can use Lambda to extend other AWS services with custom logic or create your own backend services that operate at AWS scale, performance, and security.

## Project Structure
terraform-code1
```
.
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── terraform.tfvars
```
terraform-code2
```
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   └── index.js
```

## Deployment with Terraform
Note: There are 2 Terraform codes
- terraform-code1: executes Lambda code within Terraform
- terraform-code2: executes the code through a zip file

The `terraform/` directory contains Terraform configuration files to deploy the Lambda function:
- `main.tf`: Contains the main Terraform configuration for creating the Lambda function and IAM role.
- `variables.tf`: Defines the input variables for the Terraform configuration.
- `terraform.tfvars`: Sets the values for the defined variables.

Note: When deploying Lambda, it will be created without an event, meaning the event has to be created manually.

To deploy using Terraform:
```
cd terraform
terraform init
terraform plan
terraform apply
```

![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWS%20lambda%20service/imagenes/lambda-1.png)

## Deployment with CloudFormation
The `Cloudformation-code/` directory contains a CloudFormation template to deploy the Lambda function:
- `stack.yml`: CloudFormation template that defines the Lambda function and IAM role.

## Getting Started
[Add instructions on how to get started with the project, including any prerequisites, setup steps, and usage examples.]
