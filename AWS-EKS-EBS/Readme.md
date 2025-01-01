# EKS Cluster Configuration with Terraform

This repository contains Terraform configuration files to deploy an Amazon EKS (Elastic Kubernetes Service) cluster with persistent storage using the AWS EBS CSI Driver. This setup provides a comprehensive storage solution for applications requiring data persistence in Kubernetes.

## AWS EBS (Elastic Block Store)

EBS is a block storage service provided by AWS, designed to be used with Amazon EC2 and Amazon EKS. It functions as a virtual hard drive in the cloud.

## Architecture Overview

The configuration creates:
- A VPC with public, private, and intra subnets across 2 availability zones.
- An EKS cluster (version 1.30) with managed node groups.
- Integration of the AWS EBS CSI Driver.
- Default GP3 storage class configuration.

## Requirements

- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- kubectl
- Helm >= 2.9.0

## Installation

1. Initialize Terraform:
   ```
   terraform init
   ```
2. Review the planned changes:
   ```
   terraform plan
   ```
3. Apply the configuration:
   ```
   terraform apply
   ```

## Verification

## Infrastructure Components

### VPC Configuration

- CIDR: 10.0.0.0/16
- 2 Availability Zones
- Public, Private, and Intra Subnets
- NAT Gateway enabled
- DNS hostnames and support enabled

### EKS Cluster

- Kubernetes Version: 1.30
- Public endpoint access enabled
- IRSA (IAM Roles for Service Accounts) enabled
- Managed node group configuration:
  - Instance type: t3.medium
  - Minimum size: 1
  - Maximum size: 10
  - Desired size: 1

### Add-ons

- CoreDNS
- EKS Pod Identity Agent
- Kube Proxy
- VPC CNI
- AWS EBS CSI Driver

### Storage

- Default StorageClass: gp3-default
- EBS CSI Driver integration
- Encrypted volumes by default
- Volume binding mode: WaitForFirstConsumer

