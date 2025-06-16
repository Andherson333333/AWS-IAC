# AWS Site-to-Site VPN with Terraform & Libreswan

[![Terraform](https://img.shields.io/badge/Terraform-1.0+-623CE4?style=flat&logo=terraform)](https://terraform.io)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?style=flat&logo=amazon-aws)](https://aws.amazon.com)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A production-ready implementation of AWS Site-to-Site VPN using Terraform for infrastructure automation and Libreswan as Customer Gateway. This setup demonstrates how to securely connect on-premises networks to AWS VPC using IPSec tunnels.

## Table of Contents

- [Architecture](#architecture)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Initial Setup](#initial-setup)
- [Deployment](#deployment)
- [Libreswan Configuration](#libreswan-configuration)
- [Verification](#verification)
- [Infrastructure Components](#infrastructure-components)
- [Troubleshooting](#troubleshooting)
- [Cost Estimation](#cost-estimation)
- [Documentation](#documentation)
- [License](#license)

## Architecture

![vpn-connect](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC-VPN-site-to-site/imagenes/vpn-site-to-site-6.png)

## Features

- **Infrastructure as Code** with Terraform modules
- **High Availability** with dual IPSec tunnels
- **Static Routing** configuration
- **Automated Security Groups** setup
- **Complete documentation** and troubleshooting guides
- **Cost-optimized** resource allocation

## Prerequisites

### Required Software
- [Terraform](https://terraform.io/downloads) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate permissions
- SSH access to Ubuntu EC2 instance

### AWS Permissions
Your AWS credentials need permissions for:
- VPC, Subnets, Route Tables
- EC2 instances and Security Groups
- VPN Gateway and Customer Gateway
- Site-to-Site VPN connections

### Network Requirements
- Public IP address for Customer Gateway
- EC2 Key Pair in target region

## Initial Setup

### 1. Clone Repository

```bash
git clone https://github.com/your-username/aws-site-to-site-vpn.git
cd aws-site-to-site-vpn
```

### 2. Update Configuration

Edit `customer-gateway-resource.tf` variables:

```hcl
# Update your Customer Gateway public IP
resource "aws_customer_gateway" "vyos_lab" {
  ip_address = "YOUR_PUBLIC_IP_HERE"  # ← Change this
}

# Update EC2 key pair
module "ec2_test_server" {
  key_name = "YOUR_KEY_PAIR_NAME"     # ← Change this
}
```

**Other parts to edit:**

#### AWS Region (optional)
```hcl
locals {
  region = "us-east-1"  # ← Change if using different region
}
```

#### VPC CIDR (optional)
```hcl
locals {
  vpc_cidr = "10.1.0.0/16"  # ← Change if you want different range
}
```

#### On-Premises Network (optional)
```hcl
local_ipv4_network_cidr = "172.31.0.0/16"  # ← Change to your current network
```

## Deployment

### 3. Deploy Infrastructure

```bash
# Initialize Terraform
terraform init

# Plan deployment
terraform plan

# Apply configuration
terraform apply
```

### 4. Get VPN Configuration

```bash
# Display VPN connection details
terraform output vpn_connection_info

# Get Pre-Shared Keys
terraform output useful_commands
```

## Libreswan Configuration

### 1. Connect to Customer Gateway

```bash
ssh -i your-key.pem ubuntu@YOUR_PUBLIC_IP
```

### 2. Install and Configure Libreswan

```bash
# Install Libreswan
sudo apt update && sudo apt install libreswan -y

# Enable IP forwarding
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.ipv4.conf.all.accept_redirects=0
sudo sysctl -w net.ipv4.conf.all.send_redirects=0

# Make settings permanent
cat << EOF | sudo tee -a /etc/sysctl.conf
net.ipv4.ip_forward = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
EOF
```

### 3. Configure VPN Tunnel

Create `/etc/ipsec.d/aws-vpn.conf`:

```bash
conn Tunnel1
    authby=secret
    auto=start
    left=%defaultroute
    leftid=YOUR_PUBLIC_IP
    right=AWS_TUNNEL_IP
    type=tunnel
    ikelifetime=8h
    keylife=1h
    keyexchange=ike
    leftsubnet=172.31.0.0/16
    rightsubnet=10.1.0.0/16
    dpddelay=10
    dpdtimeout=30
    dpdaction=restart_by_peer
```

Create `/etc/ipsec.d/aws-vpn.secrets`:

```bash
YOUR_PUBLIC_IP AWS_TUNNEL_IP: PSK "YOUR_PRE_SHARED_KEY"
```

### 4. Start VPN Service

```bash
sudo systemctl enable ipsec
sudo systemctl start ipsec
sudo systemctl status ipsec
```

## Verification

### 1. Verify Route Propagation

Check that VGW routes are properly propagated to private route tables:

**CLI Verification:**
```bash
aws ec2 describe-route-tables --query 'RouteTables[*].Routes[?VpcPeeringConnectionId==null]'
```

![Route Tables CLI Output](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC-VPN-site-to-site/imagenes/vpn-site-to-site-5.png)

**AWS Console Verification:**
- Navigate to **VPC** → **Route Tables**
- Select private route tables
- Verify `172.31.0.0/16` route points to VGW with **Propagated = Yes**

![Route Table GUI - us-east-1a](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC-VPN-site-to-site/imagenes/vpn-site-to-site-3.png)
![Route Table GUI - us-east-1b](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC-VPN-site-to-site/imagenes/vpn-site-to-site-4.png)

### 2. Check VPN Tunnel Status

**AWS Console:**
1. Navigate to **VPC** → **Site-to-Site VPN Connections**
2. Verify at least one **Tunnel Status** = **UP**
3. Check **Customer Gateway Address** matches your public IP

![VPN Connection Status](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC-VPN-site-to-site/imagenes/vpn-site-to-site-2.png)

### 3. Test End-to-End Connectivity

**From Customer Gateway to Private Instance:**
```bash
ping 10.1.1.232
```

![Successful Ping Test](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC-VPN-site-to-site/imagenes/vpn-site-to-site-1.png)

### 4. Verify Libreswan Status

```bash
# Check IPSec status
sudo ipsec status

# Verify traffic flow
sudo ipsec trafficstatus

# Check XFRM policies
sudo ip xfrm policy
sudo ip xfrm state
```

### 5. Network Interface Verification

```bash
# Check routing table
ip route show | grep 10.1

# Verify network interfaces
ip addr show
```

## Infrastructure Components

| Resource | Count | Purpose |
|----------|-------|---------|
| VPC | 1 | Custom network (10.1.0.0/16) |
| Private Subnets | 2 | Workload isolation across AZs |
| Public Subnets | 2 | Internet-facing resources |
| Internet Gateway | 1 | Internet connectivity |
| Virtual Private Gateway | 1 | AWS VPN endpoint |
| Customer Gateway | 1 | On-premises VPN endpoint |
| Site-to-Site VPN | 1 | Encrypted tunnel connection |
| EC2 Instance | 1 | Test target (t2.micro) |
| Security Groups | 1 | Network access control |

## Troubleshooting

### Diagnostic Commands

```bash
# IPSec logs
sudo journalctl -u ipsec -f

# Configuration verification
sudo ipsec verify

# Connection debugging
sudo ipsec whack --debug-all

# Restart service
sudo systemctl restart ipsec
```

### Common Issues

#### One Tunnel DOWN (Normal Behavior)
- **Symptom**: One tunnel shows "Down" while the other is "Up"
- **Cause**: Expected behavior - only one active tunnel needed
- **Solution**: No action required

#### Connectivity Failure
- Verify Security Groups allow ICMP
- Confirm VGW route propagation
- Review Libreswan configuration

## Cost Estimation

| Service | Monthly Cost (us-east-1) |
|---------|-------------------------|
| Site-to-Site VPN Connection | ~$36.00 |
| Virtual Private Gateway | $0.00 |
| EC2 t2.micro | ~$8.50 (Free Tier eligible) |
| Data Transfer | Variable |
| **Total** | **~$45/month** |

## Documentation

- [AWS Site-to-Site VPN User Guide](https://docs.aws.amazon.com/vpn/latest/s2svpn/)
- [Libreswan Documentation](https://libreswan.org/wiki/Main_Page)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Built for the AWS community**
