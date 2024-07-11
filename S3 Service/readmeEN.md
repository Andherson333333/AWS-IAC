# Amazon S3 (Simple Storage Service) Project

This project demonstrates the setup and management of Amazon S3 buckets using both Terraform and CloudFormation, following AWS best practices.

## Table of Contents
- [What is Amazon S3?](#what-is-amazon-s3)
- [Key Features](#key-features)
- [Common Use Cases](#common-use-cases)
- [How It Works](#how-it-works)
- [Creating an S3 Bucket with Terraform](#creating-an-s3-bucket-with-terraform)
- [Creating an S3 Bucket with CloudFormation](#creating-an-s3-bucket-with-cloudformation)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)

## What is Amazon S3?

Amazon S3 is a cloud object storage service that offers industry-leading scalability, data availability, security, and performance. Users can store and retrieve any amount of data at any time and from anywhere on the web.

## Key Features

- **Object Storage**: S3 stores data as objects within buckets.
- **Scalability**: Highly scalable, capable of handling large amounts of data and a high number of requests.
- **Durability and Availability**: Designed for 99.999999999% durability and 99.99% availability.
- **Security**: Provides encryption in transit (SSL/TLS) and at rest, along with access permissions via bucket policies and Access Control Lists (ACLs).
- **Versioning**: Maintains multiple versions of an object.
- **Replication**: Supports Cross-Region Replication (CRR).
- **AWS Service Integration**: Seamlessly integrates with other AWS services.

## Common Use Cases

- Content Storage and Distribution
- Backup and Recovery
- Archiving
- Big Data and Analytics
- Application File Storage

## How It Works

### Creating a Bucket
1. Access the Amazon S3 console.
2. Click "Create bucket".
3. Enter a unique bucket name and select the region.
4. Configure security and permissions options.
5. Complete the bucket creation.

### Uploading Objects
1. Select the target bucket.
2. Click "Upload".
3. Select files from your computer.
4. Configure storage options and permissions.
5. Start the upload.

### Managing Objects
- Enable versioning to maintain multiple object versions.
- Configure replication to copy objects to other buckets in different regions.
- Manage access using bucket policies and ACLs.

## Creating an S3 Bucket with Terraform

This project includes Terraform code to create an S3 bucket with best practices, including versioning, lifecycle policies, and default encryption. The code is located in the `terraform-code` folder.

### Key Components:

- `aws_s3_bucket`: Creates an S3 bucket with specified name and tags, enabling default AES256 encryption.
- `aws_s3_bucket_lifecycle_configuration`: Configures lifecycle rules for the bucket:
  - Transitions objects to GLACIER storage class after 30 days.
  - Expires objects after 365 days.
  - Expires non-current versions after 90 days.
- `aws_s3_bucket_versioning`: Enables bucket versioning.

![S3 Diagram](https://github.com/Andherson333333/AWS-IAC/blob/main/S3%20Service/imagenes/s3-1.png)

## Creating an S3 Bucket with CloudFormation

This project also includes a CloudFormation template to create an S3 bucket with best practices. The template is located in the `cloudformation-template.yaml` file.

### Template Features:

- **Versioning Enabled**: Maintains multiple versions of objects.
- **Lifecycle Rules Configured**: Automatically manages object transition and expiration.
- **Default Encryption Enabled**: Ensures all objects are stored encrypted.

### Configurable Parameters:

- `BucketName`: The name of the S3 bucket (default: "andherson-s3-demo-xyz")
- `Environment`: The environment for which the bucket is created (default: "Dev")
- `Project`: The project associated with the bucket (default: "S3Demo")

### Key Components:

- **Lifecycle Configuration**: 
  - Transitions objects to GLACIER storage class after 30 days.
  - Expires objects after 365 days.
  - Expires non-current versions after 90 days.
- **Bucket Encryption**: Enables server-side encryption with AES256.
- **Versioning**: Enables bucket versioning.
- **Tags**: Adds tags for Environment and Project.

### Outputs:

- `BucketId`: Provides the name of the created S3 bucket.

## Project Structure

```
.
├── terraform-code/
│   ├── main.tf
│   └── variables.tf
├── cloudformation-template.yaml
└── README.md
```

## Getting Started

### With Terraform:

1. Clone this repository.
2. Navigate to the `terraform-code` directory.
3. Update the `variables.tf` file with your desired bucket name and tags.
4. Run the following commands:

   ```
   terraform init
   terraform plan
   terraform apply
   ```

### With CloudFormation:

1. Access the AWS CloudFormation console.
2. Create a new stack and upload the `cloudformation-template.yaml` file.
3. Configure the parameters according to your needs.
4. Review and create the stack.

5. Confirm the creation by checking the AWS S3 console.

---

For more information on Amazon S3 pricing and advanced configurations, please refer to the [official AWS documentation](https://aws.amazon.com/s3/).
