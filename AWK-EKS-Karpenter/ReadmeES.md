# Cluster EKS con Autoescalado Karpenter 

Este repositorio contiene la configuración de Terraform para desplegar un cluster Amazon EKS con Karpenter para el aprovisionamiento y escalado automático de nodos.

## ¿Qué es Karpenter?

Karpenter es un planificador de nodos automático (node autoscaler) de código abierto para Kubernetes en AWS. Sus principales características son:

* Se integra directamente con AWS para provisionar nodos (instancias EC2) de forma dinámica basándose en las necesidades de los pods pendientes en el clúster.
* A diferencia de Cluster Autoscaler, Karpenter puede seleccionar diferentes tipos de instancias EC2 y zonas de disponibilidad para optimizar el costo y la disponibilidad.
* Toma decisiones de escalado en segundos, lo que permite una respuesta más rápida a los cambios en la demanda de recursos.
* Puede consolidar eficientemente las cargas de trabajo mediante la migración de pods y la terminación de nodos infrautilizados.

## Prerrequisitos

- AWS CLI configurado
- Terraform >= 1.0
- kubectl
- Helm >= 2.9.0

## Proveedores Requeridos

- hashicorp/aws >= 5.0
- gavinbunney/kubectl >= 1.14.0
- hashicorp/helm >= 2.9.0

## Arquitectura

![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWK-EKS-Karpenter/imagenes/karpenet-2.png)


La configuración incluye:
- VPC con subredes públicas, privadas e internas en 2 zonas de disponibilidad
- Cluster EKS (versión 1.30)
- Autoescalador Karpenter
- Addons principales de EKS (CoreDNS, kube-proxy, vpc-cni, pod-identity-agent)

![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWK-EKS-Karpenter/imagenes/karpenter-permisos-1.png)

### Arquitectura de Red y Componentes

#### Distribución de Componentes por Subredes

1. **Plano de Control (Control Plane)**
   - Ubicación: Subredes Intra (/24)
     * Primera AZ: 10.0.52.0/24
     * Segunda AZ: 10.0.53.0/24
   - Características:
     * Completamente aislado
     * Sin acceso a Internet
     * Gestionado por AWS
     * Comunicación segura con los nodos worker

2. **Nodos Worker**
   - Ubicación: Subredes Privadas (/20)
     * Primera AZ: 10.0.0.0/20
     * Segunda AZ: 10.0.16.0/20
   - Características:
     * Acceso a Internet a través de NAT Gateway
     * Gestionados por Karpenter
     * Escalado automático según demanda
     * Sin IPs públicas directas

3. **Recursos Públicos**
   - Ubicación: Subredes Públicas (/24)
     * Primera AZ: 10.0.48.0/24
     * Segunda AZ: 10.0.49.0/24
   - Usos:
     * Load Balancers públicos
     * Recursos que requieren IP pública
     * Acceso directo a Internet

#### Flujo de Red
- El tráfico entre workers y control plane va a través de ENIs en las subredes intra
- Los workers acceden a Internet y servicios AWS vía NAT Gateway
- Ingress al cluster se maneja a través de las subredes públicas

### Componentes Principales

#### EKS Cluster
- Versión: 1.30
- Endpoint público habilitado
- IRSA habilitado para seguridad mejorada
- Addons básicos habilitados:
  - CoreDNS para resolución DNS
  - kube-proxy para networking
  - vpc-cni para redes de pods
  - pod-identity-agent para autenticación

#### Grupo de Nodos Inicial
- Tipo de instancia: t3.medium
- Capacidad: min 1, max 10 nodos
- Se ejecuta en subredes privadas
- Gestionado por EKS

#### Karpenter Autoscaler
- Desplegado en namespace dedicado
- Configurado para usar AWS Pod Identity
- NodePool configurado para:
  - Instancias: t3.small, t3.medium, t3.large
  - Tipo de capacidad: bajo demanda
  - AMI: Amazon Linux 2023
  - Límite de CPU: 100
  - Consolidación automática cuando los nodos están vacíos

## Implementación con Terraform

### Estructura del código

El código de Terraform está organizado en módulos y recursos para facilitar el despliegue y la gestión:

```
├── locals.tf                 # Variables locales
├── providers.tf              # Configuración de proveedores
├── vpc.tf                    # Módulo VPC
├── eks.tf                    # Módulo EKS
├── karpenter/                # Configuración de Karpenter
│   ├── karpenter-config.tf   # Configuración general
│   ├── karpenter-controller.tf  # Instalación del controlador
│   ├── karpenter-namespace.tf   # Namespace dedicado
│   └── karpenter-nodes.tf    # NodeClass y NodePool
└── README.md                 # Documentación
```

### Orden de creación

El orden de creación de recursos es:

1. VPC y componentes de red
2. Cluster EKS y grupo de nodos inicial
3. Namespace de Karpenter
4. Roles y políticas IAM de Karpenter
5. Release de Helm de Karpenter
6. NodeClass y NodePool de Karpenter

### Etiquetas clave (tags) y su propósito

Las etiquetas son fundamentales para que los componentes se descubran entre sí:

| Etiqueta | Ubicación | Propósito |
|----------|-----------|-----------|
| `karpenter.sh/discovery` | Subredes privadas | Permite a Karpenter identificar en qué subredes debe provisionar los nodos |
| `karpenter.sh/discovery` | Grupos de seguridad | Permite a Karpenter aplicar los grupos de seguridad adecuados a los nodos creados |
| `kubernetes.io/role/internal-elb` | Subredes privadas | Indica a AWS que estas subredes pueden alojar balanceadores internos |
| `kubernetes.io/role/elb` | Subredes públicas | Indica a AWS que estas subredes pueden alojar balanceadores públicos |

### VPC y Configuración de Red

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
  
  # IMPORTANTE: Etiquetas para subredes privadas que permiten descubrimiento por Karpenter
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    "karpenter.sh/discovery"         = local.name
  }
  
  # Etiquetas para subredes públicas
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
    "subnet_type"            = "public"
  }
}
```

### EKS y Grupos de Nodos

```terraform
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.2"

  cluster_name    = local.name
  cluster_version = "1.30"

  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access           = true
  enable_irsa                              = true

  # IMPORTANTE: Etiquetas para grupos de seguridad que permiten descubrimiento por Karpenter
  node_security_group_tags = merge(local.tags, {
    "karpenter.sh/discovery" = local.name
  })
  
  # Grupo de nodos inicial
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

### Configuración de Karpenter

#### Namespace dedicado

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

#### Políticas IAM y Pod Identity

```terraform
module "eks_karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  
  cluster_name = module.eks.cluster_name
  namespace    = "karpenter"
  
  # Configuración para usar Pod Identity (recomendado sobre IRSA)
  enable_pod_identity             = true
  create_pod_identity_association = true
  
  # Permisos adicionales necesarios para los nodos
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}
```

#### Instalación con Helm

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

#### NodeClass y NodePool

```terraform
# EC2NodeClass define el tipo de instancia que Karpenter puede crear
resource "kubectl_manifest" "karpenter_node_class" {
  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1beta1
    kind: EC2NodeClass
    metadata:
      name: default
    spec:
      amiFamily: AL2023
      role: ${module.eks_karpenter.node_iam_role_name}
      # Usa las etiquetas para descubrir subredes y grupos de seguridad
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

# NodePool define la estrategia de escalado
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

## Guía de despliegue

### 1. Preparación

Asegúrate de tener las credenciales AWS configuradas:
```bash
aws configure
```

### 2. Personalización (opcional)

Puedes modificar variables clave en `locals.tf`:
```terraform
locals {
  name     = "my-eks"          # Nombre del cluster
  region   = "us-east-1"       # Región AWS
  vpc_cidr = "10.0.0.0/16"     # CIDR de la VPC
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)
}
```

### 3. Verificación y despliegue

Revisa el plan de Terraform:
```bash
terraform plan
```

Despliega la infraestructura:
```bash
terraform apply -auto-approve
```

### 4. Configuración de kubectl

Configura kubectl para acceder al cluster:
```bash
aws eks update-kubeconfig --region us-east-1 --name my-eks
```

### 5. Verificación de Karpenter

Verifica el estado de Karpenter:
```bash
kubectl get pods -n karpenter
kubectl get nodeclass,nodepool
```

![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWK-EKS-Karpenter/imagenes/karpenter-6.png)

- Inflando para verificar que funcione
  
![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWK-EKS-Karpenter/imagenes/karpenter-5.png)

- Verificacion creacion
  
![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWK-EKS-Karpenter/imagenes/karpenter-3.png)

- Cerrando los nodos
  
![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWK-EKS-Karpenter/imagenes/karpenter-8.png)

## Observación y pruebas

### Probar el autoescalado

Para probar que Karpenter funciona correctamente, despliega una aplicación que requiera recursos:

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

Aplica el deployment:
```bash
kubectl apply -f test-deployment.yaml
```

Observa cómo Karpenter aprovisiona nuevos nodos:
```bash
kubectl get nodes -w
kubectl logs -f -n karpenter -l app.kubernetes.io/name=karpenter -c controller
```

### Limpieza

Elimina primero los recursos de Kubernetes:
```bash
kubectl delete deployment inflate
```

Espera a que Karpenter consolide y elimine los nodos, luego destruye la infraestructura:
```bash
terraform destroy -auto-approve
```

## Solución de problemas

### Verificación de etiquetas

Si Karpenter no está creando nodos, verifica las etiquetas:

```bash
# Verificar etiquetas de subredes
aws ec2 describe-subnets --filters "Name=tag:karpenter.sh/discovery,Values=my-eks" --query "Subnets[*].{SubnetId:SubnetId,Tags:Tags}"

# Verificar etiquetas de grupos de seguridad
aws ec2 describe-security-groups --filters "Name=tag:karpenter.sh/discovery,Values=my-eks" --query "SecurityGroups[*].{GroupId:GroupId,Tags:Tags}"
```

### Logs de Karpenter

Revisa los logs de Karpenter:

```bash
kubectl logs -n karpenter -l app.kubernetes.io/name=karpenter -c controller
```

## Recursos adicionales

- [Documentación oficial de Karpenter](https://karpenter.sh/)
- [Guía de mejores prácticas](https://karpenter.sh/v0.32/getting-started/getting-started-with-karpenter/)
- [Terraform AWS EKS Module](https://github.com/terraform-aws-modules/terraform-aws-eks)

