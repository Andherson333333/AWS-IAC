# Implementación de EKS sin Módulos

Este directorio contiene código Terraform para implementar Amazon EKS utilizando recursos nativos de Terraform (sin módulos).

## Arquitectura

Esta implementación crea:

- VPC personalizada con subredes públicas y privadas
- NAT Gateway para permitir que los nodos privados accedan a internet
- Cluster EKS versión 1.30
- Grupo de nodos gestionado con instancias t3.medium
- Roles IAM necesarios para EKS y los nodos trabajadores

## Prerrequisitos

- AWS CLI configurado con permisos adecuados
- Terraform ≥ 1.0
- kubectl (opcional, para gestionar el cluster después del despliegue)

## Estructura de Archivos

- `provider.tf`: Configuración del proveedor AWS
  - Define la versión del proveedor AWS (~> 5.49)
  - Establece la región desde la variable local
  - Requiere versión mínima de Terraform 1.0

- `local.tf`: Variables locales (entorno, región, nombre del cluster)
  - Define entorno "staging"
  - Configura región "us-east-2"
  - Especifica zonas de disponibilidad exactas (us-east-2a, us-east-2b)
  - Define nombre del cluster y versión de Kubernetes

- `vpc.tf`: Definición completa de VPC, subredes, tablas de rutas y NAT
  - Crea una VPC con CIDR 10.0.0.0/16
  - Define 4 subredes con bloques CIDR específicos:
    - Dos subredes privadas (10.0.0.0/19 y 10.0.32.0/19)
    - Dos subredes públicas (10.0.64.0/19 y 10.0.96.0/19)
  - Implementa Internet Gateway para acceso a internet
  - Configura NAT Gateway en una subred pública para que las subredes privadas accedan a internet
  - Crea tablas de rutas separadas para subredes públicas y privadas
  - Añade etiquetas específicas para EKS en las subredes

- `eks.tf`: Configuración del cluster EKS y roles IAM asociados
  - Define rol IAM para el plano de control de EKS
  - Asocia la política AmazonEKSClusterPolicy al rol
  - Crea el cluster EKS con la versión especificada
  - Configura el control de acceso con autenticación API
  - Otorga permisos de administrador al creador del cluster

- `node-eks.tf`: Definición del grupo de nodos y roles IAM para los nodos
  - Crea rol IAM para los nodos trabajadores
  - Asocia políticas necesarias:
    - AmazonEKSWorkerNodePolicy
    - AmazonEKS_CNI_Policy
    - AmazonEC2ContainerRegistryReadOnly
  - Define un grupo de nodos gestionado con instancias t3.medium
  - Configura capacidad bajo demanda con auto-escalado (0-10 nodos)
  - Incluye configuración para actualizaciones graduales

## Detalles de Implementación

### Networking

A diferencia del enfoque con módulos, aquí cada componente de red está definido explícitamente:

1. **VPC y Subnets**:
   - La VPC se define con su bloque CIDR, soporte DNS y nombres de host
   - Las subredes tienen bloques CIDR fijos y predecibles
   - Las subredes públicas están configuradas para asignar IPs públicas automáticamente

2. **Routing**:
   - Las tablas de rutas se crean manualmente para cada tipo de subred
   - La tabla de rutas privada direcciona todo el tráfico a través del NAT Gateway
   - La tabla de rutas pública direcciona el tráfico directamente al Internet Gateway

3. **NAT Gateway**:
   - Se implementa un único NAT Gateway en la primera subred pública
   - Se asigna una IP elástica específica para el NAT

4. **Etiquetas para EKS**:
   - Las subredes incluyen etiquetas específicas para que EKS pueda identificarlas
   - Las etiquetas `kubernetes.io/cluster/${local.env}-${local.eks_name}` permiten descubrimiento automático

### IAM y Seguridad

Se definen explícitamente todos los roles y políticas necesarios:

1. **Rol del Cluster**:
   - Rol específico para el servicio EKS
   - Política de confianza que permite solo al servicio EKS asumir el rol
   - Permisos mínimos necesarios para operar

2. **Rol de Nodos**:
   - Rol para instancias EC2 que ejecutarán los nodos
   - Políticas para permitir:
     - Comunicación con el plano de control
     - Operaciones de red con CNI
     - Descarga de imágenes de contenedores

### Cluster EKS

El cluster se configura con:
- Acceso público habilitado
- Acceso privado deshabilitado (se puede habilitar para mayor seguridad)
- Configuración específica de autenticación API
- Permisos de creador del cluster

### Nodos Trabajadores

El grupo de nodos incluye:
- Tipo de instancia t3.medium (equilibrio costo/rendimiento)
- Capacidad bajo demanda (no spot)
- Etiquetas para identificar su rol como "general"
- Configuración de escalado (0-10 nodos)
- Configuración de actualizaciones para minimizar tiempo de inactividad

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
   aws eks update-kubeconfig --region us-east-2 --name staging-my-eks
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

Esta implementación ofrece control granular sobre cada aspecto:

- Modifica manualmente las políticas IAM en `eks.tf` y `node-eks.tf`
  ```hcl
  # Ejemplo: Añadir política adicional para los nodos
  resource "aws_iam_role_policy_attachment" "custom_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    role       = aws_iam_role.nodes.name
  }
  ```

- Ajusta la configuración de red en `vpc.tf`
  ```hcl
  # Ejemplo: Cambiar CIDR de VPC
  resource "aws_vpc" "main" {
    cidr_block = "172.16.0.0/16"
    # Otros parámetros...
  }
  
  # Ejemplo: Ajustar subredes
  resource "aws_subnet" "private_zone1" {
    cidr_block = "172.16.0.0/19"
    # Otros parámetros...
  }
  ```

- Personaliza los grupos de nodos en `node-eks.tf`
  ```hcl
  # Ejemplo: Cambiar tipo de instancia y capacidad
  resource "aws_eks_node_group" "general" {
    # Configuración existente...
    
    capacity_type  = "SPOT"  # Cambiar a instancias spot
    instance_types = ["m5.large", "m5a.large"]  # Múltiples tipos para spot
    
    scaling_config {
      desired_size = 3
      max_size     = 20
      min_size     = 2
    }
  }
  ```

- Cambia la región y zonas de disponibilidad en `local.tf`
  ```hcl
  locals {
    env         = "production"  # Cambiar a producción
    region      = "eu-west-1"   # Cambiar región
    zone1       = "eu-west-1a"  # Actualizar zona
    zone2       = "eu-west-1b"  # Actualizar zona
    # Resto de configuración...
  }
  ```

## Referencias

- [Documentación de AWS EKS](https://docs.aws.amazon.com/eks/)
- [Referencia de recursos Terraform para AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Guía de AWS para implementar EKS](https://aws.amazon.com/blogs/containers/amazon-eks-cluster-multi-zone-auto-scaling-groups/)
