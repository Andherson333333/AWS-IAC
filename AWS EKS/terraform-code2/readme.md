# EKS Implementation without Modules

This directory contains Terraform code to implement Amazon EKS using native Terraform resources (without modules).

## Architecture

This implementation creates:

- Custom VPC with public and private subnets
- NAT Gateway to allow private nodes to access the internet
- EKS cluster version 1.30
- Managed node group with t3.medium instances
- IAM roles required for EKS and worker nodes

## Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform ≥ 1.0
- kubectl (optional, for managing the cluster after deployment)

## File Structure

- `provider.tf`: AWS provider configuration
  - Defines the AWS provider version (~> 5.49)
  - Sets the region from the local variable
  - Requires minimum Terraform version 1.0

- `local.tf`: Local variables (environment, region, cluster name)
  - Defines "staging" environment
  - Configures "us-east-2" region
  - Specifies exact availability zones (us-east-2a, us-east-2b)
  - Defines cluster name and Kubernetes version

- `vpc.tf`: Complete definition of VPC, subnets, route tables, and NAT
  - Creates a VPC with CIDR 10.0.0.0/16
  - Defines 4 subnets with specific CIDR blocks:
    - Two private subnets (10.0.0.0/19 and 10.0.32.0/19)
    - Two public subnets (10.0.64.0/19 and 10.0.96.0/19)
  - Implements Internet Gateway for internet access
  - Configures NAT Gateway in a public subnet for private subnets to access the internet
  - Creates separate route tables for public and private subnets
  - Adds specific tags for EKS in the subnets

- `eks.tf`: EKS cluster configuration and associated IAM roles
  - Defines IAM role for the EKS control plane
  - Associates the AmazonEKSClusterPolicy to the role
  - Creates the EKS cluster with the specified version
  - Configures access control with API authentication
  - Grants administrator permissions to the cluster creator

- `node-eks.tf`: Definition of node group and IAM roles for the nodes
  - Creates IAM role for worker nodes
  - Associates necessary policies:
    - AmazonEKSWorkerNodePolicy
    - AmazonEKS_CNI_Policy
    - AmazonEC2ContainerRegistryReadOnly
  - Defines a managed node group with t3.medium instances
  - Configures on-demand capacity with auto-scaling (0-10 nodes)
  - Includes configuration for gradual updates

## Implementation Details

### Networking

Unlike the module approach, here each network component is explicitly defined:

1. **VPC and Subnets**:
   - The VPC is defined with its CIDR block, DNS support, and hostnames
   - Subnets have fixed and predictable CIDR blocks
   - Public subnets are configured to automatically assign public IPs

2. **Routing**:
   - Route tables are manually created for each subnet type
   - The private route table routes all traffic through the NAT Gateway
   - The public route table routes traffic directly to the Internet Gateway

3. **NAT Gateway**:
   - A single NAT Gateway is implemented in the first public subnet
   - A specific Elastic IP is assigned to the NAT

4. **EKS Tags**:
   - Subnets include specific tags so EKS can identify them
   - The `kubernetes.io/cluster/${local.env}-${local.eks_name}` tags allow automatic discovery

### IAM and Security

All necessary roles and policies are explicitly defined:

1. **Cluster Role**:
   - Specific role for the EKS service
   - Trust policy that only allows the EKS service to assume the role
   - Minimum permissions needed to operate

2. **Node Role**:
   - Role for EC2 instances that will run the nodes
   - Policies to allow:
     - Communication with the control plane
     - Network operations with CNI
     - Container image downloads

### EKS Cluster

The cluster is configured with:
- Public access enabled
- Private access disabled (can be enabled for greater security)
- Specific API authentication configuration
- Cluster creator permissions

### Worker Nodes

The node group includes:
- t3.medium instance type (cost/performance balance)
- On-demand capacity (not spot)
- Labels to identify their role as "general"
- Scaling configuration (0-10 nodes)
- Update configuration to minimize downtime

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
   aws eks update-kubeconfig --region us-east-2 --name staging-my-eks
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

This implementation offers granular control over every aspect:

- Manually modify IAM policies in `eks.tf` and `node-eks.tf`
  ```hcl
  # Example: Add additional policy for nodes
  resource "aws_iam_role_policy_attachment" "custom_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    role       = aws_iam_role.nodes.name
  }
  ```

- Adjust network configuration in `vpc.tf`
  ```hcl
  # Example: Change VPC CIDR
  resource "aws_vpc" "main" {
    cidr_block = "172.16.0.0/16"
    # Other parameters...
  }
  
  # Example: Adjust subnets
  resource "aws_subnet" "private_zone1" {
    cidr_block = "172.16.0.0/19"
    # Other parameters...
  }
  ```

- Customize node groups in `node-eks.tf`
  ```hcl
  # Example: Change instance type and capacity
  resource "aws_eks_node_group" "general" {
    # Existing configuration...
    
    capacity_type  = "SPOT"  # Change to spot instances
    instance_types = ["m5.large", "m5a.large"]  # Multiple types for spot
    
    scaling_config {
      desired_size = 3
      max_size     = 20
      min_size     = 2
    }
  }
  ```

- Change region and availability zones in `local.tf`
  ```hcl
  locals {
    env         = "production"  # Change to production
    region      = "eu-west-1"   # Change region
    zone1       = "eu-west-1a"  # Update zone
    zone2       = "eu-west-1b"  # Update zone
    # Rest of configuration...
  }
  ```

## References

- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/)
- [Terraform resource reference for AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS guide to implementing EKS](https://aws.amazon.com/blogs/containers/amazon-eks-cluster-multi-zone-auto-scaling-groups/)
