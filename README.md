# Repositorio de AWS y Terraform

Este repositorio contiene configuraciones para diversos servicios de AWS en Terraform y CloudFormation.

## Estructura del Repositorio

| Carpeta | Descripción | Tecnologías |
|---------|-------------|-------------|
| **Cloudformation** | Conceptos y ejemplos de CloudFormation | `CONCEPTO` `TEMPLATES` `STACKS` |
| **Terraform** | Conceptos y mejores prácticas de Terraform | `CONCEPTO` `MODULES` `VARIABLES` |
| **EC2 servicio** | Configuraciones de instancias EC2 | `EC2` `TERRAFORM` `CLOUDFORMATION` |
| **IAM Service** | Gestión de identidad y acceso | `IAM` `TERRAFORM` `CLOUDFORMATION` |
| **S3 Service** | Servicio de almacenamiento de objetos | `S3` `TERRAFORM` `CLOUDFORMATION` |
| **VPC servicio** | Configuración de redes virtuales | `VPC` `MODULE` `TERRAFORM` `CLOUDFORMATION` |
| **S3 backend remote** | Configuración de backend para Terraform | `S3` `DYNAMODB` `TERRAFORM` |
| **CloudWatch Service** | Monitoreo y alertas | `CLOUDWATCH` `TERRAFORM` `CLOUDFORMATION` |
| **AWS EKS** | Elastic Kubernetes Service básico | `MODULE` `TERRAFORM` `VPC` `POLICE` `CODE` |
| **AWK-EKS-Karpenter** | Configuración de auto-escalado de nodos Kubernetes | `KARPENTER` `HELM` `TERRAFORM` |
| **AWS lambda mostrar servicios** | Funciones Lambda para listar servicios AWS | `TERRAFORM` `PYTHON` `LAMBDA` |
| **AWS lambda service** | Implementaciones de servicios serverless | `TERRAFORM` `CLOUDFORMATION` `LAMBDA` |
| **AWS-EKS-EBS** | Almacenamiento persistente para Kubernetes | `TERRAFORM` `EKS` `EBS` `MODULE` |
| **Three Tier Web** | Arquitectura web de tres capas | `VPC` `SG` `RDB` `LB` `LAUNCH TEMPLATE` `SCALING` `IAM` `TERRAFORM` |
| **AWS-EKS-LB+NGINX** | Configuración de ingress y balanceo de carga | `EKS` `ALB` `HELM` `NGINX` `TERRAFORM` |
| **VPC +LoadBalancer+Autosacalin+Ec2** | Infraestructura web escalable | `VPC` `ASG` `ALB` `EC2` `TERRAFORM` |

## Requisitos

- AWS CLI v2+
- Terraform v1.0+
- kubectl (para configuraciones de EKS)
- Cuenta de AWS con permisos adecuados

## Instalación

Hay un script llamado `install.sh` donde se instalan los complementos necesarios de requisitos.

## Categorías de Servicios

### Conceptos de Infraestructura como Código
- Terraform
- Cloudformation

### Servicios de Computación
- EC2 servicio
- AWS lambda mostrar servicios
- AWS lambda service

### Servicios de Contenedores
- AWS EKS
- AWK-EKS-Karpenter
- AWS-EKS-EBS
- AWS-EKS-LB+NGINX

### Servicios de Almacenamiento
- S3 Service
- S3 backend remote

### Redes
- VPC servicio
- VPC +LoadBalancer+Autosacalin+Ec2

### Monitoreo
- CloudWatch Service

### Seguridad y Acceso
- IAM Service

### Arquitecturas Completas
- Three Tier Web
