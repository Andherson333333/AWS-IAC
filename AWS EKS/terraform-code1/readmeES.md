# Implementación de EKS con Módulos de Terraform

Este directorio contiene código Terraform para implementar Amazon EKS utilizando los módulos oficiales de AWS.

## Arquitectura

![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWS%20EKS/imagenes/eks-1.png)

![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWS%20EKS/imagenes/eks-permisis-1.png)

Esta implementación crea:

- VPC con subredes públicas, privadas e intra (utilizando el módulo `terraform-aws-modules/vpc/aws`)
- Cluster EKS versión 1.30 (utilizando el módulo `terraform-aws-modules/eks/aws`)
- Grupo de nodos gestionados con instancias t3.medium
- Addons básicos: CoreDNS, kube-proxy, y VPC CNI

## Prerrequisitos

- AWS CLI configurado con permisos adecuados
- Terraform ≥ 1.0
- kubectl (opcional, para gestionar el cluster después del despliegue)

## Estructura de Archivos

- `provider.tf`: Configuración de proveedores (AWS, kubectl, helm)
  - Define los proveedores necesarios para interactuar con AWS, con kubectl para comandos K8s y Helm para deployments
  - Requiere versión mínima de Terraform 1.0
  - Configura un alias para la región de AWS especificada en local.tf

- `local.tf`: Variables locales (nombre, región, etiquetas)
  - Define el nombre del cluster EKS ("my-eks")
  - Configura la región "us-east-1"
  - Establece el CIDR block para la VPC (10.0.0.0/16)
  - Configura zonas de disponibilidad dinámicamente
  - Define etiquetas comunes para todos los recursos

- `vpc.tf`: Definición de VPC y subredes mediante módulo
  - Implementa una VPC completa con el módulo oficial de AWS
  - Crea tres tipos de subredes:
    - Subredes públicas: Para balanceadores de carga y recursos accesibles desde internet
    - Subredes privadas: Para nodos de EKS con acceso a internet a través de NAT Gateway
    - Subredes intra: Para el plano de control de EKS, sin acceso a internet
  - Configura NAT Gateway para permitir que los recursos en subredes privadas accedan a internet
  - Añade etiquetas específicas para la integración con Kubernetes

- `eks.tf`: Configuración del cluster EKS mediante módulo
  - Implementa un cluster EKS completo usando el módulo oficial de AWS
  - Configura la versión de Kubernetes 1.30
  - Habilita permisos de administrador para el creador del cluster
  - Configura acceso público al endpoint del API Server
  - Habilita IAM Roles for Service Accounts (IRSA)
  - Instala addons esenciales: CoreDNS, kube-proxy, y VPC CNI
  - Define un grupo de nodos gestionados con instancias t3.medium
  - Utiliza las subredes privadas para los nodos y las subredes intra para el plano de control

- `data.tf`: Data sources (zonas de disponibilidad, tokens ECR)
  - Obtiene dinámicamente las zonas de disponibilidad disponibles en la región
  - Configura token de autorización para acceder a ECR público

## Detalles de Implementación

### Networking

El módulo VPC crea:
- Una VPC con CIDR 10.0.0.0/16
- Subredes distribuidas entre dos zonas de disponibilidad
- Subredes privadas con rangos CIDR calculados dinámicamente
- Subredes públicas con rangos CIDR más pequeños
- Un NAT Gateway compartido por todas las subredes privadas
- Habilita soporte DNS para facilitar la resolución de nombres dentro del cluster

### Cluster EKS

El módulo EKS configura:
- Un cluster EKS de última versión
- Acceso público al endpoint de API (puede restringirse a IPs específicas)
- Grupo de nodos con auto-escalado (1-10 nodos)
- Etiquetas específicas para la integración con otros servicios de AWS
- Addons oficiales que permiten la funcionalidad básica del cluster

## Despliegue

1. **Inicializar Terraform**:
   ```bash
   terraform init
   ```

2. **Revisar el plan de despliegue**:
   ```bash
   terraform plan
   ```

3. **Aplicar la configuración**:
   ```bash
   terraform apply
   ```

4. **Configurar kubectl** (después del despliegue):
   ```bash
   aws eks update-kubeconfig --region us-east-1 --name my-eks
   ```

## Verificación

Para verificar que tu cluster está funcionando correctamente:

```bash
kubectl get nodes
kubectl get pods --all-namespaces
```

## Limpieza

Para eliminar todos los recursos creados:

```bash
terraform destroy
```

## Personalización

Para modificar esta implementación:

- Ajusta el tamaño y tipo de instancias en `eks.tf`
  ```hcl
  eks_managed_node_groups = {
    General = {
      instance_types = ["t3.large"]  # Cambiar a un tipo más potente
      min_size     = 2               # Aumentar capacidad mínima
      max_size     = 20              # Aumentar capacidad máxima
      desired_size = 3               # Establecer capacidad inicial
    }
  }
  ```

- Modifica la región y zonas de disponibilidad en `local.tf`
  ```hcl
  locals {
    name   = "production-eks"        # Cambiar nombre del cluster
    region = "eu-west-1"             # Cambiar a otra región
    azs    = slice(data.aws_availability_zones.available.names, 0, 3)  # Usar 3 AZs
  }
  ```

- Cambia la configuración de red en `vpc.tf`
  ```hcl
  module "vpc" {
    # Cambiar CIDR, habilitar endpoints de VPC, etc.
    cidr = "172.16.0.0/16"
    enable_vpn_gateway = true
  }
  ```

## Referencias

- [Documentación del módulo VPC](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
- [Documentación del módulo EKS](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)
- [Mejores prácticas de EKS](https://aws.github.io/aws-eks-best-practices/)
