# AWS TriTier: Scalable Web Infrastructure with Terraform

## Table of Contents
* [Architecture Overview](#item1)
* [Description](#item2)
* [Main Components](#item3)
* [Prerequisites](#item4)
* [Deployment](#item5)

<a name="item1"></a>
## Architecture Overview
![Architecture Diagram](https://github.com/aws-samples/aws-three-tier-web-architecture-workshop/blob/main/application-code/web-tier/src/assets/3TierArch.png)

This project implements a three-tier web architecture in AWS using Terraform. The architecture includes a public web tier, a private application tier, and an Aurora MySQL database.

<a name="item2"></a>
## Description
This architecture consists of:
- A public Application Load Balancer (ALB) that directs traffic to the web tier.
- Nginx web servers in the web tier that serve a React.js application and redirect API calls.
- An internal ALB that directs traffic to the application tier.
- Node.js application servers in the application tier.
- A multi-AZ Aurora MySQL database.

<a name="item3"></a>
## Main Components
- VPC with public, private, and database subnets
- Security groups for each tier
- Internal and external load balancers
- Auto Scaling groups for web and application tiers
- Aurora MySQL database cluster
- IAM roles and instance profiles

<a name="item4"></a>
## Prerequisites
- AWS Account
- Terraform installed
- AWS CLI configured

<a name="item5"></a>
## Deployment
To configure the AMIs, you can follow this documentation: https://catalog.us-east-1.prod.workshops.aws/workshops/85cd2bb2-7f79-4e96-bdee-8078e469752a/en-US/part6/autoscaling

1. Configure the App tier
   - Install MySQL client
   - Verify the RDS endpoint
   - Configure the Db.config.js file in the /app-tier location
   - Create an AMI of the instance

2. Configure Nginx
   - Verify the internal load balancer
   - Configure nginx
   - Verify connection
   - Create an AMI of the instance

3. Replace the AMI in Terraform

4. Apply Terraform code
   - VPC
     ![VPC Diagram](https://github.com/Andherson333333/AWS-IAC/blob/main/Three%20Tier%20Web/imagenes/project-T3-8.png)
   - Load Balancer
     ![Load Balancer Diagram](https://github.com/Andherson333333/AWS-IAC/blob/main/Three%20Tier%20Web/imagenes/project-T3-6.png)
   - EC2
     ![EC2 Diagram](https://github.com/Andherson333333/AWS-IAC/blob/main/Three%20Tier%20Web/imagenes/project-T3-5.png)
   - RDS
     ![RDS Diagram](https://github.com/Andherson333333/AWS-IAC/blob/main/Three%20Tier%20Web/imagenes/project-T3-7.png)
   - Web
     ![Web Diagram](https://github.com/Andherson333333/AWS-IAC/blob/main/Three%20Tier%20Web/imagenes/project-T3-3.png)
   - Database
     ![Database Diagram](https://github.com/Andherson333333/AWS-IAC/blob/main/Three%20Tier%20Web/imagenes/project-T3-4.png)
