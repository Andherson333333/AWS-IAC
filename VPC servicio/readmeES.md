# Understanding and Creating a VPC in AWS

## Table of Contents
* [What is a VPC?](#item1)
* [Advantages and Disadvantages](#item2)
* [Main VPC Components](#item3)
* [Creating a VPC](#item4)
* [Creation via Graphical Interface](#item5)
* [Creation with IaC (Terraform and CloudFormation)](#item6)

<a name="item1"></a>
## What is a VPC?
A VPC (Virtual Private Cloud) is a virtual network you create in the cloud. It allows you to have your own private section of the Internet, like having your own network within a larger network. Within this VPC, you can create and manage various resources, such as servers, databases, and storage.
This virtual network is completely isolated from other users' networks, ensuring that your data and applications are secure and protected.
With a VPC, you have control over your network environment. You can define access rules, configure firewalls, and set up security groups to regulate who can access your resources and how they can communicate.

<a name="item2"></a>
## Advantages and Disadvantages

| Advantages of a VPC                  | Disadvantages of a VPC                     |
|--------------------------------------|-------------------------------------------|
| 1. Enhanced Security                 | 1. Complex Configuration                  |
| 2. Total Network Control             | 2. Additional Costs                       |
| 3. Scalability                       | 3. Potential Risk of Errors               |
| 4. Increased Availability            | 4. Dependence on Internet Connection      |
| 5. Integration with Cloud Services   | 5. Specific Knowledge Requirements        |
| 6. Controlled Costs                  | 6. Possible Resource Limitations          |

<a name="item3"></a>
## Main VPC Components
1. VPC
2. Subnets
3. IP addressing
4. Network Access Control List (NACL)
5. Security Group
6. Routing
7. Gateways and endpoints
8. Peering connections
9. Traffic Mirroring
10. VPC Flow Logs
11. VPN connections

<a name="item4"></a>
## Creating a VPC
A VPC can be created using several methods:
- GUI (Graphical User Interface)
- CLI (Command Line Interface)
- SDK (Software Development Kit)
- IaC (Infrastructure as Code)

<a name="item5"></a>
## Creation via Graphical Interface
1. Service - VPC
2. Create VPC (set the CIDR IP range)
3. Create VPC Subnet (This helps create redundancy, one subnet per recommended zone)
4. Create ACL (When creating the subnet, one is created by default for each subnet)
5. Create routing table (A default main table is created to communicate my VPC internally without internet access)
6. Create Internet Gateway (Responsible for giving internet access to my VPC, it's my exit door)
7. Create routing table (associated with the Internet Gateway)

<a name="item6"></a>
## Creation with IaC (Terraform and CloudFormation)
In this case, we will create with IaC using 2 tools: Terraform and CloudFormation. This VPC will contain the following components:
1. VPC
2. Subnets
3. IP addressing
4. Network Access Control List (NACL)
5. Security Group
6. Routing
7. Gateways

The code is divided as follows:
1. Terraform-code1: will contain Terraform code but without modules with a single main file
2. Terraform-code2: will contain code but in module form
3. CloudFormation: will contain 1 stack

All 3 configurations do the same thing, just in different ways.

![Diagram](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC%20servicio/imagenes/vpc.png)
