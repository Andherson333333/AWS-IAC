## Table of Contents
* [What is IAM?](#item1)
* [What is a User?](#item2)
* [What is a Group?](#item3)
* [What are Policies?](#item4)
* [What are Roles?](#item5)
* [Creating Users and Policies](#item6)
* [Terraform](#item7)
* [Deployment with Terraform](#item8)
* [Deployment with CloudFormation](#item9)

<a name="item1"></a>
## What is IAM?
IAM (Identity and Access Management): IAM is the AWS service that allows you to securely manage access to AWS resources. With IAM, you can create and manage users, groups, roles, and permissions to control who has access to which resources within your AWS account.

<a name="item2"></a>
## What is a User?
User: A user in IAM represents a person or an application that interacts with AWS. Each user has a unique username and access credentials used to log in to the AWS console or access AWS resources via the API.

<a name="item3"></a>  
## What is a Group?
Group: A group in IAM is a collection of users who share the same sets of permissions. Instead of assigning permissions to each user individually, you can add users to groups and then assign permissions to those groups. This facilitates permission management on a large scale.

<a name="item4"></a>
## What are Policies?
Policies: Policies in IAM are JSON documents that define the permissions and actions that a user, group, or role can perform on specific AWS resources. Policies are attached to users, groups, or roles to define what operations they can perform and on which resources.

<a name="item5"></a>
## What are Roles?
Roles: A role in IAM is similar to a user, but it is used to grant temporary permissions to a trusted entity, such as a user from another AWS service, an application, or an external service. Roles are commonly used to delegate access between AWS services and to allow applications to access AWS resources securely without exposing credentials.

<a name="item6"></a>
## Creating Users and Policies
Note: To create users, you must have an account with sufficient permissions to create them.  
There are several ways to create users in AWS:
- AWS Console
- AWS CLI (Command Line Interface)
- AWS SDKs (such as Python, Java, Node.js, etc.)
- Infrastructure as Code (IAC), using tools like Terraform or AWS CloudFormation
In this case, we will create them with IAC.

<a name="item7"></a>
## Terraform 
The code for deployment is located in the terraform folder. There are 2 terraform folders:
- 1 terraform-code1 with policies created by AWS and using them
- 2 terraform-code2 with manually created policies

<a name="item8"></a>
## Deployment with Terraform
- Installation of Terraform
- Creation of the Terraform structure with common files `provider.tf` `variables.tf` `output.tf` `main.tf` `terraform.tfvars`
- We apply the configurations with Terraform commands
terraform-code1
![Diagram](https://github.com/Andherson333333/AWS-IAC/blob/main/IAM%20Service/imagenes/terraform-4.png)
terraform-code2
![Diagram](https://github.com/Andherson333333/AWS-IAC/blob/main/IAM%20Service/imagenes/terraform-2.png)

## Deployment with CloudFormation
The code for deployment is located in the cloudformation-code folder
