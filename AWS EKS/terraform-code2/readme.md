# Visión General (Sin modulos)

La configuración de Terraform en este proyecto configura:

1. Una VPC con subredes públicas, privadas e internas
2. Un cluster EKS
3. Un grupo de nodos gestionados de EKS

## Prerrequisitos

- Terraform (>= 1.0)
- AWS CLI configurado con las credenciales apropiadas
- kubectl
- helm

## Versiones de Proveedores

- Proveedor AWS (>= 5.0)
- Proveedor kubectl (>= 1.14.0)
- Proveedor Helm (>= 2.9.0)

## Configuración

### Variables Locales

- `env`: Entorno (por defecto: "staging")
- `region`: Región de AWS (por defecto: "us-east-2")
- `zone1` y `zone2`: Zonas de disponibilidad
- `eks_name`: Nombre del cluster EKS
- `eks_version`: Versión de EKS

### VPC y Redes

- Crea una VPC con CIDR 10.0.0.0/16
- Configura subredes públicas y privadas en dos zonas de disponibilidad
- Implementa un Internet Gateway y un NAT Gateway

### Cluster EKS

- Despliega un cluster EKS con acceso público
- Configura un grupo de nodos gestionados con instancias t3.large
- Aplica las políticas IAM necesarias para el cluster y los nodos
