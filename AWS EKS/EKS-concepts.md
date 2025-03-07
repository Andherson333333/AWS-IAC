# Amazon EKS Fundamental Concepts

## What is Amazon EKS?
Amazon Elastic Kubernetes Service (EKS) is a managed service that makes it easy to run Kubernetes on AWS without needing to install, operate, and maintain your own Kubernetes control plane. Kubernetes is an open-source platform for managing containerized applications, and Amazon EKS simplifies its use by handling the complex tasks associated with cluster management.

## Main Components of EKS

### Control Plane
The control plane in EKS is responsible for managing and coordinating the Kubernetes cluster and includes:

- **API Server**: Handles incoming requests from users and applications.
- **etcd**: Key-value store that maintains the state of the entire cluster.
- **Scheduler**: Allocates resources to pods based on declared requirements.
- **Controller Manager**: Monitors and maintains the desired state of cluster objects.

In Amazon EKS, the control plane is fully managed by AWS and distributed across multiple availability zones to ensure high availability and fault tolerance.

### Worker Nodes
Worker nodes are virtual machines (EC2 instances) that run containerized applications and are controlled by the control plane. They include:

- **kubelet**: Communicates the control plane's instructions to the node and monitors pods.
- **Container runtime**: Runs the containers (Docker, containerd, etc.).
- **kube-proxy**: Manages network rules and enables communication between pods and services.

## Types of Clusters in Amazon EKS

### 1. Managed Clusters
- AWS manages the control plane.
- Options for worker nodes include:
  - **Self-managed Nodes**: EC2 instances that you configure and manage manually.
  - **EKS Managed Nodes**: AWS handles the creation and lifecycle management of nodes.
  - **Fargate**: Serverless option where you don't need to manage EC2 instances.

### 2. EKS Anywhere
- Allows running Kubernetes in on-premises environments with AWS support.
- Provides consistency between cloud and on-premises environments.

### 3. EKS on AWS Fargate
- Runs pods in a serverless environment.
- Doesn't require provisioning or managing nodes.
- Billed per pod instead of per instance.

## Advantages of Amazon EKS

- **High availability**: Control plane distributed across multiple availability zones.
- **Security**: Integration with IAM, encryption at rest, and secure VPC networking.
- **Managed updates**: AWS facilitates Kubernetes version updates.
- **AWS ecosystem**: Integration with services such as CloudWatch, ALB, ACM, etc.
- **Community**: Compatibility with the open-source Kubernetes tools ecosystem.

## Approach Comparison

| Feature | Managed EKS | Self-Managed K8s | EKS Anywhere | EKS on Fargate |
|---------|-------------|------------------|--------------|----------------|
| Control plane management | AWS | User | AWS (software) | AWS |
| Node management | User or AWS | User | User | No nodes |
| Location | AWS Cloud | AWS Cloud | On-premises | AWS Cloud |
| Pricing model | Per cluster + instances | Instances only | License + hardware | Per pod |
| Scale | High | Variable | Medium | High and serverless |
| Ideal use case | Cloud production | Total control | Hybrid environments | Variable workloads |

## Best Practices

1. **Networking**: Use VPC with private subnets for worker nodes.
2. **Security**: Implement restrictive IAM policies and use IRSA (IAM Roles for Service Accounts).
3. **High availability**: Distribute nodes across multiple availability zones.
4. **Monitoring**: Configure CloudWatch and Prometheus for observability.
5. **Updates**: Keep the cluster updated with recent Kubernetes versions.

## Additional Resources
- [Amazon EKS Official Documentation](https://docs.aws.amazon.com/eks/)
- [EKS Best Practices Guide](https://aws.github.io/aws-eks-best-practices/)
- [EKS Examples Repository](https://github.com/aws-samples/amazon-eks-ami)
