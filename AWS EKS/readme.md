# AWS EKS with Terraform

This repository contains resources to implement Amazon Elastic Kubernetes Service (EKS) using Terraform, with two different approaches.

## Repository Content

- **[terraform-code1](./terraform-code1)**: EKS implementation using Terraform modules.
- **[terraform-code2](./terraform-code2)**: EKS implementation without using modules (native resources).
- **[EKS General Documentation](./EKS-concepts.md)**: EKS fundamental concepts.

## Project Structure

```
AWS EKS/
│
├── terraform-code1/               # Implementation using Terraform modules
│   ├── data.tf                    # Data sources (availability zones)
│   ├── eks.tf                     # EKS module configuration
│   ├── local.tf                   # Local variables (region, name, etc.)
│   ├── provider.tf                # Provider configuration
│   ├── readme.md                  # Specific documentation
│   └── vpc.tf                     # VPC module configuration
│
├── terraform-code2/               # Implementation without modules
│   ├── eks.tf                     # Native resources for EKS cluster
│   ├── local.tf                   # Local variables
│   ├── node-eks.tf                # Worker nodes configuration
│   ├── provider.tf                # Provider configuration
│   ├── readme.md                  # Specific documentation
│   └── vpc.tf                     # Native resources for VPC
│
├── docs/                          # General documentation
│   └── EKS-overview.md            # EKS fundamental concepts
│
├── imagenes/                      # Documentation images
│   └── txt                        # Placeholder
│
├── readme.md                      # This file (English version)
└── readmeES.md                    # Spanish version
```

## What is Amazon EKS?

Amazon Elastic Kubernetes Service (EKS) is an AWS managed service that facilitates running Kubernetes without the need to install and maintain your own control plane. [Read more about EKS →](./EKS-concepts.md)

## Implementation Approaches

This repository offers two different approaches to implement EKS:

### Approach 1: Using Terraform Modules (terraform-code1)

- **Advantages**: More concise code, easier maintenance, rapid deployment
- **Ideal use case**: Teams that need to quickly deploy a standard EKS cluster
- **[View implementation →](./terraform-code1)**

### Approach 2: Without Modules (terraform-code2)

- **Advantages**: Granular control, greater customization, detailed understanding of resources
- **Ideal use case**: Teams that need high customization or want to learn about EKS
- **[View implementation →](./terraform-code2)**

## Available Documentation

- [EKS fundamental concepts](./docs/EKS-overview.md)
- [Deployment guide with modules](./terraform-code1/README.md)
- [Deployment guide without modules](./terraform-code2/README.md)

## General Requirements

- Configured AWS CLI
- Terraform ≥ 1.0
- Basic Kubernetes knowledge

---

## Languages

- [English](./readme.md)
- [Spanish](./readmeES.md)


