# EKS Cluster with Karpenter Autoscaler

This repository contains the Terraform configuration to deploy an Amazon EKS cluster with Karpenter for node provisioning and autoscaling.

## Karpenter

Karpenter is an open-source automatic node autoscaler for Kubernetes on AWS. Its key features include:

- Direct integration with AWS to dynamically provision nodes (EC2 instances) based on pending pods' needs in the cluster.
- Unlike Cluster Autoscaler, Karpenter can select different EC2 instance types and availability zones to optimize cost and availability.
- Makes scaling decisions in seconds, enabling a faster response to changes in resource demand.
- Efficiently consolidates workloads by migrating pods and terminating underutilized nodes.
- Supports advanced features like spot instances, ARM and x86 architectures, various instance families, and multi-AZ setups.
- Configured via Kubernetes Custom Resource Definitions (CRDs) for flexible provisioning policies.

## Prerequisites

- AWS CLI configured
- Terraform >= 1.0
- kubectl
- Helm >= 2.9.0

## Required Providers

- hashicorp/aws >= 5.0
- gavinbunney/kubectl >= 1.14.0
- hashicorp/helm >= 2.9.0

## Resource Creation Order

1. VPC and networking components
2. EKS cluster and initial node group
3. Karpenter namespace
4. Karpenter IAM roles and policies
5. Helm release for Karpenter
6. Karpenter NodeClass and NodePool

## Deployment

```bash
terraform init
```
```bash
terraform plan
```
```bash
terraform apply
```

## Verification

## Architecture

The configuration includes:
- A VPC with public, private, and intra subnets across 2 availability zones.
- EKS cluster (version 1.30).
- Karpenter autoscaler.
- Core EKS addons (CoreDNS, kube-proxy, vpc-cni, pod-identity-agent).

## Networking and Components Architecture

### Subnet Distribution for Components

1. **Control Plane**
   - **Location**: Intra subnets (/24)
     - AZ1: 10.0.52.0/24
     - AZ2: 10.0.53.0/24
   - **Features**:
     - Fully isolated
     - No Internet access
     - Managed by AWS
     - Secure communication with worker nodes

2. **Worker Nodes**
   - **Location**: Private subnets (/20)
     - AZ1: 10.0.0.0/20
     - AZ2: 10.0.16.0/20
   - **Features**:
     - Internet access via NAT Gateway
     - Managed by Karpenter
     - Autoscaling based on demand
     - No direct public IPs

3. **Public Resources**
   - **Location**: Public subnets (/24)
     - AZ1: 10.0.48.0/24
     - AZ2: 10.0.49.0/24
   - **Uses**:
     - Public Load Balancers
     - Resources requiring public IPs
     - Direct Internet access

### Network Flow

- Traffic between workers and the control plane flows through ENIs in intra subnets.
- Workers access the Internet and AWS services via NAT Gateway.
- Cluster ingress is managed through public subnets.

## Network Configuration

### VPC and Subnets
The VPC is configured with CIDR `10.0.0.0/16` and spans 2 availability zones with three subnet types:

1. **Private Subnets** (/20):
   - Hosts worker nodes
   - AZ1: 10.0.0.0/20
   - AZ2: 10.0.16.0/20
   - Internet access via NAT Gateway
   - Tagged for Karpenter discovery

2. **Public Subnets** (/24):
   - For resources requiring public IPs
   - AZ1: 10.0.48.0/24
   - AZ2: 10.0.49.0/24
   - Direct Internet access via Internet Gateway

3. **Intra Subnets** (/24):
   - Dedicated to EKS control plane
   - AZ1: 10.0.52.0/24
   - AZ2: 10.0.53.0/24
   - No Internet access
   - Isolated for maximum security

## Key Components

### EKS Cluster
- Version: 1.30
- Public endpoint enabled
- IRSA enabled for enhanced security
- Core addons enabled:
  - CoreDNS for DNS resolution
  - kube-proxy for networking
  - vpc-cni for pod networking
  - pod-identity-agent for authentication

### Initial Node Group
- Instance type: t3.medium
- Capacity: min 1, max 10 nodes
- Runs in private subnets
- Managed by EKS

### Karpenter Autoscaler
- Deployed in a dedicated namespace
- Configured to use AWS Pod Identity
- NodePool configured for:

