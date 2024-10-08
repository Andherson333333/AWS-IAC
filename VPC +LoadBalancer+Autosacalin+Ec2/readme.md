# AWS Infrastructure with Terraform
This project uses Terraform to configure a scalable and highly available infrastructure in AWS. It includes a VPC, public and private subnets, an Application Load Balancer, and an Auto Scaling Group for EC2 instances.

## Table of Contents
* [Architecture Overview](#item1)
* [Prerequisites](#item2)
* [Usage](#item3)
* [Configuration](#item4)
* [Components](#item5)
* [Security](#item6)
* [Scaling](#item7)
* [Cleanup](#item8)

<a name="item1"></a>
## Architecture Overview
- VPC with public and private subnets in two availability zones
- Internet Gateway for public internet access
- NAT Gateway for outbound internet access from private subnets
- Application Load Balancer in public subnets
- Auto Scaling Group of EC2 instances in private subnets
- Security groups for the Load Balancer and EC2 instances

<a name="item2"></a>
## Prerequisites
- AWS Account
- Terraform installed
- AWS CLI configured with appropriate credentials

<a name="item3"></a>
## Usage
1. Clone this repository
2. Navigate to the project directory
3. Initialize Terraform:
    ```sh
    terraform init
    ```
4. Review planned changes:
    ```sh
    terraform plan
    ```
5. Apply the Terraform configuration:
    ```sh
    terraform apply
    ```

<a name="item4"></a>
## Configuration
The main configuration parameters can be adjusted in the `variables.tf` file:
- `public_subnet_cidrs`: CIDR blocks for public subnets
- `private_subnet_cidrs`: CIDR blocks for private subnets
- `azs`: Availability zones to use
- `exposed_ports`: Ports exposed on the Load Balancer
- `exposed_ports_ec2`: Ports exposed on EC2 instances
- `ami`: AMI ID for EC2 instances
- `instance_type`: EC2 instance type

<a name="item5"></a>
## Components
- VPC
- Public and private subnets
- Internet Gateway
- NAT Gateway
- Route tables
- Security groups
- Application Load Balancer
- Launch Configuration
- Auto Scaling Group
- Auto Scaling Policy

<a name="item6"></a>
## Security
- The Load Balancer is accessible from the internet on specified ports
- EC2 instances are in private subnets and only accessible through the Load Balancer
- Outbound internet access for EC2 instances is provided through the NAT Gateway

<a name="item7"></a>
## Scaling
The Auto Scaling Group is configured to scale based on CPU utilization. The scaling policy targets 50% CPU utilization.

<a name="item8"></a>
## Cleanup
To destroy the created resources:
```sh
terraform destroy
