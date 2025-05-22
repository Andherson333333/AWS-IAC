# AWS VPC Peering with EC2 Instance Connect Endpoints

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Prerequisites](#prerequisites)
- [Deployment Instructions](#deployment-instructions)
- [Project Structure](#project-structure)
- [Validation and Testing](#validation-and-testing)
- [Cleanup Procedures](#cleanup-procedures)
- [Security Considerations](#security-considerations)
- [References](#references)
- [License](#license)

---

A comprehensive Terraform implementation to establish secure VPC-to-VPC connectivity using AWS VPC Peering, complemented with EC2 Instance Connect Endpoints for bastion-free access to private instances.

## Overview

This project automates the deployment of a multi-VPC architecture on AWS, demonstrating modern cloud networking patterns and security best practices. The infrastructure enables secure communication between isolated network segments while providing administrative access to private resources without traditional jump servers.

### Architecture Components

- **Dual VPC Configuration**: Two independent Virtual Private Clouds with complete subnet isolation
- **VPC Peering Connection**: Direct and encrypted communication path between VPC networks
- **Private EC2 Instances**: Compute resources deployed in private subnets for enhanced security
- **EC2 Instance Connect Endpoints**: AWS-managed service for secure shell access without public IP exposure
- **Infrastructure as Code**: Complete Terraform implementation using community-validated modules

## Key Features

### VPC Peering Implementation
VPC Peering establishes a network connection between two VPCs, allowing resources to communicate using private IPv4 addresses. This implementation provides:

- **Direct Network Path**: Traffic flows directly between VPCs without traversing internet gateway
- **Cost Optimization**: Eliminates NAT Gateway requirements for inter-VPC communication
- **Enhanced Security**: All traffic remains within AWS backbone infrastructure
- **Low Latency**: Direct routing path minimizes network hops

### EC2 Instance Connect Endpoints
EC2 Instance Connect Endpoints represent AWS's modern approach to secure instance access, offering:

- **Bastion Elimination**: Direct connectivity to private instances without jump servers
- **IAM Integration**: Authentication and authorization through existing AWS identity systems
- **Managed Infrastructure**: AWS handles endpoint availability and security patches
- **Audit Trail**: Complete session logging through CloudTrail integration

## Infrastructure Architecture

![VPC Peering Architecture Diagram](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC-Peering-endpoint-ec2/Imagenes/vpc-peerin-7.png)

The implemented architecture shows:
- **VPC-1** (10.1.0.0/16) and **VPC-2** (10.2.0.0/16) in us-east-1 region
- Public and private subnets distributed across availability zones us-east-1a and us-east-1b
- EC2 instances deployed in private subnets
- EC2 Instance Connect Endpoints for secure access
- Active VPC Peering connection enabling direct communication between VPCs

## Prerequisites

- **Terraform**: Version 1.0 or higher
- **AWS CLI**: Configured with appropriate credentials
- **AWS Account**: With sufficient permissions for VPC, EC2, and networking operations
- **SSH Key Pair**: Pre-existing key pair in the target AWS region

## Deployment Instructions

### Initial Configuration

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd vpc-peering-terraform
   ```

2. **Configure AWS credentials**
   ```bash
   aws configure
   # or
   export AWS_PROFILE=your-profile
   ```

3. **Update configuration variables**
   
   Edit EC2 configuration to specify your SSH key pair:
   ```hcl
   # ec2.tf
   key_name = "your-existing-key-pair-name"
   ```

### Infrastructure Deployment

1. **Initialize Terraform workspace**
   ```bash
   terraform init
   ```

2. **Review deployment plan**
   ```bash
   terraform plan
   ```

3. **Deploy infrastructure**
   ```bash
   terraform apply
   ```

## Project Structure

```
.
├── locals.tf               # Local variables and configuration
├── providers.tf            # Provider configuration and requirements
├── data.tf                 # Data sources for AMIs and availability zones
├── vpc.tf                  # VPC module configurations
├── vpc-peering.tf          # VPC peering connection configuration
├── security-groups.tf      # Security group definitions
├── ec2.tf                  # EC2 instance configurations
├── endpoint.tf             # EC2 Instance Connect Endpoints
└── README.md               # This documentation
```

## Validation and Testing

### Infrastructure Verification

After successful deployment, verify the following components:

1. **VPC Configuration**
   
   ![VPC List](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC-Peering-endpoint-ec2/Imagenes/vpc-peerin-5.png)
   
   - Confirm two VPCs are created with correct CIDR blocks
   - Validate subnet creation across multiple availability zones
   - Verify route table configuration for inter-VPC communication

2. **VPC Peering Status**
   
   ![VPC Peering Connection](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC-Peering-endpoint-ec2/Imagenes/vpc-peerin-6.png)
   
   - Ensure peering connection status shows as "Active"
   - Confirm route propagation to both VPC route tables
   - Validate security group rules allow required traffic

3. **EC2 Instance Connect Endpoints**
   
   ![EC2 Instances](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC-Peering-endpoint-ec2/Imagenes/vpc-peerin-4.png)
   
   - Verify endpoints are in "Available" state
   - Confirm endpoint placement in private subnets
   - Review associated security group configurations

### Connectivity Testing

#### SSH Access via EC2 Instance Connect



#### Inter-VPC Connectivity Verification

![VPC-2 Instance Details](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC-Peering-endpoint-ec2/Imagenes/vpc-peerin-4.png)

From the connected instance, test network connectivity:

![Ping Connectivity Test](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC-Peering-endpoint-ec2/Imagenes/vpc-peerin-3.png)

![Ping Connectivity Test](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC-Peering-endpoint-ec2/Imagenes/vpc-peerin-2.png)

As shown in the capture, the successful ping from the instance in VPC-1 (10.1.10.7) to the instance in VPC-2 (10.2.11.104) confirms that:
- VPC Peering connection is working correctly
- Route tables are properly configured
- Security groups allow ICMP traffic between VPCs
- Average latency is under 2ms, demonstrating direct connection efficiency

### Network Analysis

Verify routing configuration using AWS CLI:
```bash
# List route tables
aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$(terraform output -raw vpc_1_id)"

# Examine peering connection
aws ec2 describe-vpc-peering-connections --filters "Name=status-code,Values=active"
```

## Cleanup Procedures

To remove all deployed infrastructure:
```bash
terraform destroy
```

## Security Considerations

- **Network Isolation**: Resources deployed in private subnets without direct internet access
- **Access Control**: SSH access restricted to authorized key pairs
- **Encryption**: All inter-VPC traffic encrypted by default
- **Audit Logging**: EC2 Instance Connect sessions logged in CloudTrail
- **Least Privilege Principle**: Security groups configured with minimal required access

## References

- [AWS VPC Peering Documentation](https://docs.aws.amazon.com/vpc/latest/peering/)
- [EC2 Instance Connect Endpoint User Guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/connect-using-eice.html)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
