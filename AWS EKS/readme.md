# Amazon EKS (Elastic Kubernetes Service)

This repository aims to explain what EKS is and how to deploy it with Terraform, offering two possible configurations:

- **Terraform1**: Using modules.
- **Terraform2**: Without modules.

## Requirements

- AWS CLI
- Terraform

## Deployment

1. **Initialize Terraform**:
   ```
   terraform init
   ```

2. **Plan the infrastructure**:
   ```
   terraform plan
   ```

3. **Destroy the infrastructure**:
   ```
   terraform destroy
   ```

---

## What is Amazon EKS?
Amazon Elastic Kubernetes Service (EKS) is a managed service that makes it easy to run Kubernetes on AWS without needing to install, operate, and maintain a Kubernetes control plane. Kubernetes is an open-source platform for managing containerized applications, and Amazon EKS simplifies its use by handling the complex tasks associated with cluster management.

## What is the Control Plane?
The control plane in EKS is responsible for managing and coordinating the Kubernetes cluster. It includes components such as:
- **API Server**: Manages incoming requests from users and applications.
- **Etcd**: A key-value store that holds the state of the entire cluster.
- **Scheduler**: Allocates resources to pods based on declared requirements.
- **Controller Manager**: Monitors and maintains the desired state of cluster objects.

In Amazon EKS, the control plane is fully managed by AWS and distributed across multiple availability zones to ensure high availability and fault tolerance.

## What are Worker Nodes?
Worker nodes are the virtual machines (EC2 instances) that run containerized applications and are controlled by the control plane. Worker nodes include:
- **kubelet**: Communicates the control plane’s instructions to the node and monitors pods.
- **Container runtime**: Runs the containers (Docker, containerd, etc.).
- **Kube-proxy**: Manages network rules and enables communication between pods and services.

## Types of Clusters in Amazon EKS
1. **Managed Clusters**:
   - AWS manages the control plane.
   - Users are responsible for the worker nodes (self-managed nodes) or can use AWS-managed worker nodes (EKS Managed Nodes).

2. **EKS Anywhere**:
   - Allows Kubernetes to run on-premises with AWS support.

3. **EKS on AWS Fargate**:
   - Runs pods in a serverless environment without managing nodes.

## Key Differences
| Feature                   | Managed by AWS                | Self-Managed Nodes              |
|---------------------------|--------------------------------|----------------------------------|
| **Control Plane**         | Fully managed                 | Managed by AWS                  |
| **Worker Nodes**          | EKS Managed Nodes or Fargate  | EC2 instances managed by users  |
| **Auto Scaling**          | Supported in Fargate and EKS Autoscaler | Requires manual configuration   |
| **On-Premises Operations**| EKS Anywhere                  | Not available                   |

## Advantages of Amazon EKS
- **High availability**: The control plane is distributed across multiple availability zones.
- **Integration with AWS services**: Integrated with IAM, CloudWatch, ALB, and more.
- **Flexibility**: Supports multiple options for node execution and environments.
- **Security**: Encryption at rest and secure traffic by default.

## Additional Resources
- [Amazon EKS Official Documentation](https://docs.aws.amazon.com/eks/)
- [Introduction to Kubernetes](https://kubernetes.io/docs/concepts/)
- [AWS Hands-on Tutorials for EKS](https://aws.amazon.com/getting-started/hands-on/)

