# Repositorio de AWS y Terraform

Este repositorio contiene configuraciones para diversos servicios de AWS en Terraform y CloudFormation.

## Estructura del Repositorio

| Carpeta | Descripción | Tecnologías |
|---------|-------------|-------------|
| **Cloudformation** | Conceptos y ejemplos de CloudFormation | <span style="color:red">`CONCEPTO`</span> <span style="color:red">`TEMPLATES`</span> <span style="color:red">`STACKS`</span> |
| **Terraform** | Conceptos y mejores prácticas de Terraform | <span style="color:red">`CONCEPTO`</span> <span style="color:red">`MODULES`</span> <span style="color:red">`VARIABLES`</span> |
| **EC2 servicio** | Configuraciones de instancias EC2 | <span style="color:red">`EC2`</span> <span style="color:red">`TERRAFORM`</span> <span style="color:red">`CLOUDFORMATION`</span> |
| **IAM Service** | Gestión de identidad y acceso | <span style="color:red">`IAM`</span> <span style="color:red">`TERRAFORM`</span> <span style="color:red">`CLOUDFORMATION`</span> |
| **S3 Service** | Servicio de almacenamiento de objetos | <span style="color:red">`S3`</span> <span style="color:red">`TERRAFORM`</span> <span style="color:red">`CLOUDFORMATION`</span> |
| **VPC servicio** | Configuración de redes virtuales | <span style="color:red">`VPC`</span> <span style="color:red">`MODULE`</span> <span style="color:red">`TERRAFORM`</span> <span style="color:red">`CLOUDFORMATION`</span> |
| **S3 backend remote** | Configuración de backend para Terraform | <span style="color:red">`S3`</span> <span style="color:red">`DYNAMODB`</span> <span style="color:red">`TERRAFORM`</span> |
| **CloudWatch Service** | Monitoreo y alertas | <span style="color:red">`CLOUDWATCH`</span> <span style="color:red">`TERRAFORM`</span> <span style="color:red">`CLOUDFORMATION`</span> |
| **AWS EKS** | Elastic Kubernetes Service básico | <span style="color:red">`MODULE`</span> <span style="color:red">`TERRAFORM`</span> <span style="color:red">`VPC`</span> <span style="color:red">`POLICE`</span> <span style="color:red">`CODE`</span> |
| **AWK-EKS-Karpenter** | Configuración de auto-escalado de nodos Kubernetes | <span style="color:red">`KARPENTER`</span> <span style="color:red">`HELM`</span> <span style="color:red">`TERRAFORM`</span> |
| **AWS lambda mostrar servicios** | Funciones Lambda para listar servicios AWS | <span style="color:red">`TERRAFORM`</span> <span style="color:red">`PYTHON`</span> <span style="color:red">`LAMBDA`</span> |
| **AWS lambda service** | Implementaciones de servicios serverless | <span style="color:red">`TERRAFORM`</span> <span style="color:red">`CLOUDFORMATION`</span> <span style="color:red">`LAMBDA`</span> |
| **AWS-EKS-EBS** | Almacenamiento persistente para Kubernetes | <span style="color:red">`TERRAFORM`</span> <span style="color:red">`EKS`</span> <span style="color:red">`EBS`</span> <span style="color:red">`MODULE`</span> |
| **Three Tier Web** | Arquitectura web de tres capas | <span style="color:red">`VPC`</span> <span style="color:red">`SG`</span> <span style="color:red">`RDB`</span> <span style="color:red">`LB`</span> <span style="color:red">`LAUNCH TEMPLATE`</span> <span style="color:red">`SCALING`</span> <span style="color:red">`IAM`</span> <span style="color:red">`TERRAFORM`</span> |
| **AWS-EKS-LB+NGINX** | Configuración de ingress y balanceo de carga | <span style="color:red">`EKS`</span> <span style="color:red">`ALB`</span> <span style="color:red">`HELM`</span> <span style="color:red">`NGINX`</span> <span style="color:red">`TERRAFORM`</span> |
| **VPC +LoadBalancer+Autosacalin+Ec2** | Infraestructura web escalable | <span style="color:red">`VPC`</span> <span style="color:red">`ASG`</span> <span style="color:red">`ALB`</span> <span style="color:red">`EC2`</span> <span style="color:red">`TERRAFORM`</span> |

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
