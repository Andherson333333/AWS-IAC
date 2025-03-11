# EKS Cluster with Karpenter Auto-scaling

This repository contains the Terraform configuration to deploy an Amazon EKS cluster with Karpenter for automatic node provisioning and scaling.

## What is Karpenter?

Karpenter is an open-source node autoscaler for Kubernetes on AWS. Its main features are:

* It integrates directly with AWS to dynamically provision nodes (EC2 instances) based on the needs of pending pods in the cluster.
* Unlike Cluster Autoscaler, Karpenter can select different types of EC2 instances and availability zones to optimize cost and availability.
* It makes scaling decisions in seconds, allowing for faster response to changes in resource demand.
* It can efficiently consolidate workloads by migrating pods and terminating underutilized nodes.

## Prerequisites

- AWS CLI configured
- Terraform >= 1.0
- kubectl
- Helm >= 2.9.0

## Required Providers

- hashicorp/aws >= 5.0
- gavinbunney/kubectl >= 1.14.0
- hashicorp/helm >= 2.9.0

## Architecture

![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWK-EKS-Karpenter/imagenes/karpenet-2.png)

The configuration includes:
- VPC with public, private, and internal subnets in 2 availability zones
- EKS Cluster (version 1.30)
- Karpenter Autoscaler
- Main EKS addons (CoreDNS, kube-proxy, vpc-cni, pod-identity-agent)

![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWK-EKS-Karpenter/imagenes/karpenter-permisos-1.png)


### Network Architecture and Components

#### Component Distribution by Subnet

1. **Control Plane**
   - Location: Intra Subnets (/24)
     * First AZ: 10.0.52.0/24
     * Second AZ: 10.0.53.0/24
   - Characteristics:
     * Completely isolated
     * No Internet access
     * Managed by AWS
     * Secure communication with worker nodes

2. **Worker Nodes**
   - Location: Private Subnets (/20)
     * First AZ: 10.0.0.0/20
     * Second AZ: 10.0.16.0/20
   - Characteristics:
     * Internet access through NAT Gateway
     * Managed by Karpenter
     * Automatic scaling according to demand
     * No direct public IPs

3. **Public Resources**
   - Location: Public Subnets (/24)
     * First AZ: 10.0.48.0/24
     * Second AZ: 10.0.49.0/24
   - Uses:
     * Public Load Balancers
     * Resources requiring public IP
     * Direct Internet access

#### Network Flow
- Traffic between workers and control plane goes through ENIs in the intra subnets
- Workers access Internet and AWS services via NAT Gateway
- Ingress to the cluster is handled through public subnets

### Main Components

#### EKS Cluster
- Version: 1.30
- Public endpoint enabled
- IRSA enabled for enhanced security
- Basic addons enabled:
  - CoreDNS for DNS resolution
  - kube-proxy for networking
  - vpc-cni for pod networks
  - pod-identity-agent for authentication

#### Initial Node Group
- Instance type: t3.medium
- Capacity: min 1, max 10 nodes
- Runs in private subnets
- Managed by EKS

#### Karpenter Autoscaler
- Deployed in dedicated namespace
- Configured to use AWS Pod Identity
- NodePool configured for:
  - Instances: t3.small, t3.medium, t3.large
  - Capacity type: on-demand
  - AMI: Amazon Linux 2023
  - CPU limit: 100
  - Automatic consolidation when nodes are empty

## Implementation with Terraform

### Code Structure

The Terraform code is organized into modules and resources to facilitate deployment and management:

```
├── locals.tf                 # Local variables
├── providers.tf              # Provider configuration
├── vpc.tf                    # VPC Module
├── eks.tf                    # EKS Module
├── karpenter/                # Karpenter configuration
│   ├── karpenter-config.tf   # General configuration
│   ├── karpenter-controller.tf  # Controller installation
│   ├── karpenter-namespace.tf   # Dedicated namespace
│   └── karpenter-nodes.tf    # NodeClass and NodePool
└── README.md                 # Documentation
    ReadmeES.md               # Español
```

### Creation Order

The resource creation order is:

1. VPC and network components
2. EKS Cluster and initial node group
3. Karpenter Namespace
4. Karpenter IAM roles and policies
5. Karpenter Helm Release
6. Karpenter NodeClass and NodePool

### Key Tags and Their Purpose

Tags are fundamental for components to discover each other:

| Tag | Location | Purpose |
|----------|-----------|-----------|
| `karpenter.sh/discovery` | Private subnets | Allows Karpenter to identify which subnets it should provision nodes in |
| `karpenter.sh/discovery` | Security groups | Allows Karpenter to apply the appropriate security groups to created nodes |
| `kubernetes.io/role/internal-elb` | Private subnets | Indicates to AWS that these subnets can host internal load balancers |
| `kubernetes.io/role/elb` | Public subnets | Indicates to AWS that these subnets can host public load balancers |

### VPC and Network Configuration

```terraform
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]
  intra_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 52)]
  
  # IMPORTANT: Tags for private subnets that allow discovery by Karpenter
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    "karpenter.sh/discovery"         = local.name
  }
  
  # Tags for public subnets
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
    "subnet_type"            = "public"
  }
}
```

### EKS and Node Groups

```terraform
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.2"

  cluster_name    = local.name
  cluster_version = "1.30"

  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access           = true
  enable_irsa                              = true

  # IMPORTANT: Tags for security groups that allow discovery by Karpenter
  node_security_group_tags = merge(local.tags, {
    "karpenter.sh/discovery" = local.name
  })
  
  # Initial node group
  eks_managed_node_groups = {
    karpenter = {
      instance_types = ["t3.medium"]
      min_size     = 1
      max_size     = 10
      desired_size = 1
    }
  }
}
```

### Karpenter Configuration

#### Dedicated Namespace

```terraform
resource "kubectl_manifest" "karpenter_namespace" {
  yaml_body = <<-YAML
    apiVersion: v1
    kind: Namespace
    metadata:
      name: karpenter
  YAML

  depends_on = [module.eks]
}
```

#### IAM Policies and Pod Identity

```terraform
module "eks_karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  
  cluster_name = module.eks.cluster_name
  namespace    = "karpenter"
  
  # Configuration to use Pod Identity (recommended over IRSA)
  enable_pod_identity             = true
  create_pod_identity_association = true
  
  # Additional permissions needed for nodes
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}
```

#### Helm Installation

```terraform
resource "helm_release" "karpenter" {
  namespace           = "karpenter"
  name                = "karpenter"
  repository          = "oci://public.ecr.aws/karpenter"
  repository_username = data.aws_ecrpublic_authorization_token.token.user_name
  repository_password = data.aws_ecrpublic_authorization_token.token.password
  chart               = "karpenter"
  version             = "0.37.0"
  
  values = [
    <<-EOT
    serviceAccount:
      name: ${module.eks_karpenter.service_account}
    settings:
      clusterName: ${module.eks.cluster_name}
      clusterEndpoint: ${module.eks.cluster_endpoint}
      interruptionQueue: ${module.eks_karpenter.queue_name}
    EOT
  ]
}
```

#### NodeClass and NodePool

```terraform
# EC2NodeClass defines the type of instance Karpenter can create
resource "kubectl_manifest" "karpenter_node_class" {
  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1beta1
    kind: EC2NodeClass
    metadata:
      name: default
    spec:
      amiFamily: AL2023
      role: ${module.eks_karpenter.node_iam_role_name}
      # Uses tags to discover subnets and security groups
      subnetSelectorTerms:
        - tags:
            karpenter.sh/discovery: ${module.eks.cluster_name}
      securityGroupSelectorTerms:
        - tags:
            karpenter.sh/discovery: ${module.eks.cluster_name}
      tags:
        karpenter.sh/discovery: ${module.eks.cluster_name}
  YAML
}

# NodePool defines the scaling strategy
resource "kubectl_manifest" "karpenter_node_pool" {
  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1beta1
    kind: NodePool
    metadata:
      name: default
    spec:
      template:
        spec:
          nodeClassRef:
            name: default
          requirements:
            - key: "node.kubernetes.io/instance-type"
              operator: In
              values: ["t3.small","t3.medium", "t3.large"]
            - key: "kubernetes.io/arch"
              operator: In
              values: ["amd64"]
            - key: "karpenter.sh/capacity-type"
              operator: In
              values: ["on-demand"]
      limits:
        cpu: 100
      disruption:
        consolidationPolicy: WhenEmpty
        consolidateAfter: 30s
  YAML
}
```

## Deployment Guide

### 1. Preparation

Make sure you have AWS credentials configured:
```bash
aws configure
```

### 2. Customization (optional)

You can modify key variables in `locals.tf`:
```terraform
locals {
  name     = "my-eks"          # Cluster name
  region   = "us-east-1"       # AWS region
  vpc_cidr = "10.0.0.0/16"     # VPC CIDR
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)
}
```

### 3. Verification and Deployment

Review the Terraform plan:
```bash
terraform plan
```

Deploy the infrastructure:
```bash
terraform apply -auto-approve
```

### 4. kubectl Configuration

Configure kubectl to access the cluster:
```bash
aws eks update-kubeconfig --region us-east-1 --name my-eks
```

### 5. Karpenter Verification

Verify Karpenter status:
```bash
kubectl get pods -n karpenter
kubectl get nodeclass,nodepool
```
- Antes
  
![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWK-EKS-Karpenter/imagenes/karpenter-6.png)

- Inflando para verificar que funcione
  
![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWK-EKS-Karpenter/imagenes/karpenter-5.png)

- Verificacion creacion
  
![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWK-EKS-Karpenter/imagenes/karpenter-3.png)

- Cerrando los nodos
  
![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWK-EKS-Karpenter/imagenes/karpenter-8.png)


## Observation and Testing

### Testing Auto-scaling

To test that Karpenter is working correctly, deploy an application that requires resources:

```yaml
# test-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: inflate
spec:
  replicas: 5
  selector:
    matchLabels:
      app: inflate
  template:
    metadata:
      labels:
        app: inflate
    spec:
      containers:
      - name: inflate
        image: public.ecr.aws/eks-distro/kubernetes/pause:3.7
        resources:
          requests:
            cpu: 1
```

Apply the deployment:
```bash
kubectl apply -f test-deployment.yaml
```

Observe how Karpenter provisions new nodes:
```bash
kubectl get nodes -w
kubectl logs -f -n karpenter -l app.kubernetes.io/name=karpenter -c controller
```

### Cleanup

First, delete Kubernetes resources:
```bash
kubectl delete deployment inflate
```

Wait for Karpenter to consolidate and remove nodes, then destroy the infrastructure:
```bash
terraform destroy -auto-approve
```

## Troubleshooting

### Tag Verification

If Karpenter isn't creating nodes, verify the tags:

```bash
# Verify subnet tags
aws ec2 describe-subnets --filters "Name=tag:karpenter.sh/discovery,Values=my-eks" --query "Subnets[*].{SubnetId:SubnetId,Tags:Tags}"

# Verify security group tags
aws ec2 describe-security-groups --filters "Name=tag:karpenter.sh/discovery,Values=my-eks" --query "SecurityGroups[*].{GroupId:GroupId,Tags:Tags}"
```

### Karpenter Logs

Review Karpenter logs:

```bash
kubectl logs -n karpenter -l app.kubernetes.io/name=karpenter -c controller
```

## Additional Resources

- [Official Karpenter Documentation](https://karpenter.sh/)
- [Best Practices Guide](https://karpenter.sh/v0.32/getting-started/getting-started-with-karpenter/)
- [Terraform AWS EKS Module](https://github.com/terraform-aws-modules/terraform-aws-eks)
