# EKS Implementation with Terraform Modules

This directory contains Terraform code to implement Amazon EKS using the official AWS modules.

## Architecture

![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWS%20EKS/imagenes/eks-1.png)

![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWS%20EKS/imagenes/eks-permisis-1.png)

This implementation creates:

- VPC with public, private, and intra subnets (using the `terraform-aws-modules/vpc/aws` module)
- EKS cluster version 1.30 (using the `terraform-aws-modules/eks/aws` module)
- Managed node group with t3.medium instances
- Basic addons: CoreDNS, kube-proxy, and VPC CNI

## Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform ≥ 1.0
- kubectl (optional, for managing the cluster after deployment)

## File Structure

- `provider.tf`: Provider configuration (AWS, kubectl, helm)
  - Defines the necessary providers to interact with AWS, with kubectl for K8s commands and Helm for deployments
  - Requires minimum Terraform version 1.0
  - Configures an alias for the AWS region specified in local.tf

- `local.tf`: Local variables (name, region, tags)
  - Defines the EKS cluster name ("my-eks")
  - Configures the region "us-east-1"
  - Sets the CIDR block for the VPC (10.0.0.0/16)
  - Configures availability zones dynamically
  - Defines common tags for all resources

- `vpc.tf`: VPC and subnet definition using module
  - Implements a complete VPC with the official AWS module
  - Creates three types of subnets:
    - Public subnets: For load balancers and resources accessible from the internet
    - Private subnets: For EKS nodes with internet access through NAT Gateway
    - Intra subnets: For the EKS control plane, without internet access
  - Configures NAT Gateway to allow resources in private subnets to access the internet
  - Adds specific tags for Kubernetes integration

- `eks.tf`: EKS cluster configuration using module
  - Implements a complete EKS cluster using the official AWS module
  - Configures Kubernetes version 1.30
  - Enables administrator permissions for the cluster creator
  - Configures public access to the API Server endpoint
  - Enables IAM Roles for Service Accounts (IRSA)
  - Installs essential addons: CoreDNS, kube-proxy, and VPC CNI
  - Defines a managed node group with t3.medium instances
  - Uses private subnets for nodes and intra subnets for the control plane

- `data.tf`: Data sources (availability zones, ECR tokens)
  - Dynamically obtains the available availability zones in the region
  - Configures authorization token to access public ECR

## Implementation Details

### Networking

The VPC module creates:
- A VPC with CIDR 10.0.0.0/16
- Subnets distributed across two availability zones
- Private subnets with dynamically calculated CIDR ranges
- Public subnets with smaller CIDR ranges
- A NAT Gateway shared by all private subnets
- Enables DNS support to facilitate name resolution within the cluster

### EKS Cluster

The EKS module configures:
- A latest version EKS cluster
- Public access to the API endpoint (can be restricted to specific IPs)
- Node group with auto-scaling (1-10 nodes)
- Specific tags for integration with other AWS services
- Official addons that enable basic cluster functionality

![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWS%20EKS/imagenes/eks-1.png)

![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWS%20EKS/imagenes/eks-2.png)

![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWS%20EKS/imagenes/eks-3.png)

![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWS%20EKS/imagenes/eks-4.png)

## Deployment

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **Review the deployment plan**:
   ```bash
   terraform plan
   ```

3. **Apply the configuration**:
   ```bash
   terraform apply
   ```

4. **Configure kubectl** (after deployment):
   ```bash
   aws eks update-kubeconfig --region us-east-1 --name my-eks
   ```

## Verification

To verify that your cluster is working correctly:

```bash
kubectl get nodes
kubectl get pods --all-namespaces
```

## Cleanup

To remove all created resources:

```bash
terraform destroy
```

## Customization

To modify this implementation:

- Adjust instance size and type in `eks.tf`
  ```hcl
  eks_managed_node_groups = {
    General = {
      instance_types = ["t3.large"]  # Change to a more powerful type
      min_size     = 2               # Increase minimum capacity
      max_size     = 20              # Increase maximum capacity
      desired_size = 3               # Set initial capacity
    }
  }
  ```

- Modify region and availability zones in `local.tf`
  ```hcl
  locals {
    name   = "production-eks"        # Change cluster name
    region = "eu-west-1"             # Change to another region
    azs    = slice(data.aws_availability_zones.available.names, 0, 3)  # Use 3 AZs
  }
  ```

- Change network configuration in `vpc.tf`
  ```hcl
  module "vpc" {
    # Change CIDR, enable VPC endpoints, etc.
    cidr = "172.16.0.0/16"
    enable_vpn_gateway = true
  }
  ```

## References

- [VPC module documentation](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
- [EKS module documentation](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)
- [EKS best practices](https://aws.github.io/aws-eks-best-practices/)
