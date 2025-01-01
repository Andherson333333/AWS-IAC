# Cluster EKS con Autoescalado Karpenter

Este repositorio contiene la configuración de Terraform para desplegar un cluster Amazon EKS con Karpenter para el aprovisionamiento y escalado automático de nodos.

## Karpenter

Karpenter es un planificador de nodos automático (node autoscaler) de código abierto para Kubernetes en AWS. Sus principales características son:

* Se integra directamente con AWS para provisionar nodos (instancias EC2) de forma dinámica basándose en las necesidades de los pods pendientes en el clúster.

* A diferencia de Cluster Autoscaler, Karpenter puede seleccionar diferentes tipos de instancias EC2 y zonas de disponibilidad para optimizar el costo y la disponibilidad.

* Toma decisiones de escalado en segundos, lo que permite una respuesta más rápida a los cambios en la demanda de recursos.

* Puede consolidar eficientemente las cargas de trabajo mediante la migración de pods y la terminación de nodos infrautilizados.

* Soporta características avanzadas como spot instances, ARM y x86, distintas familias de instancias, y múltiples zonas de disponibilidad.

* Se configura mediante CRDs (Custom Resource Definitions) de Kubernetes que permiten definir políticas de provisión flexibles.

## Prerrequisitos

- AWS CLI configurado
- Terraform >= 1.0
- kubectl
- Helm >= 2.9.0

## Proveedores Requeridos

- hashicorp/aws >= 5.0
- gavinbunney/kubectl >= 1.14.0
- hashicorp/helm >= 2.9.0

## Orden de creacion

El orden de creación de recursos es:

- VPC y componentes de red
- Cluster EKS y grupo de nodos inicial
- Namespace de Karpenter
- Roles y políticas IAM de Karpenter
- Release de Helm de Karpenter
- NodeClass y NodePool de Karpenter

## Despligue

```
terraform init
```
```
terraform plan
```
```
terraform apply
```

## Verificacion


## Arquitectura

La configuración incluye:
- VPC con subredes públicas, privadas e internas en 2 zonas de disponibilidad
- Cluster EKS (versión 1.30)
- Autoescalador Karpenter
- Addons principales de EKS (CoreDNS, kube-proxy, vpc-cni, pod-identity-agent)

## Arquitectura de Red y Componentes

### Distribución de Componentes por Subredes

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
    * Acceso a Internet través de NAT Gateway
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

### Flujo de Red
- El tráfico entre workers y control plane va a través de ENIs en las subredes intra
- Los workers acceden a Internet y servicios AWS vía NAT Gateway
- Ingress al cluster se maneja a través de las subredes públicas

## Configuración de Red

### VPC y Subredes
La VPC está configurada con el CIDR `10.0.0.0/16` y distribuida en 2 zonas de disponibilidad con tres tipos de subredes:

1. **Subredes Privadas** (/20):
  - Donde se ejecutan los nodos worker
  - Primera AZ: 10.0.0.0/20
  - Segunda AZ: 10.0.16.0/20
  - Acceso a internet a través de NAT Gateway
  - Etiquetadas para Karpenter discovery

2. **Subredes Públicas** (/24):
  - Para recursos que requieren IP pública
  - Primera AZ: 10.0.48.0/24
  - Segunda AZ: 10.0.49.0/24
  - Tienen acceso directo a Internet a través de Internet Gateway

3. **Subredes Intra** (/24):
  - Dedicadas al plano de control de EKS
  - Primera AZ: 10.0.52.0/24
  - Segunda AZ: 10.0.53.0/24
  - Sin acceso a Internet
  - Aisladas para máxima seguridad

## Componentes Principales

### EKS Cluster
- Versión: 1.30
- Endpoint público habilitado
- IRSA habilitado para seguridad mejorada
- Addons básicos habilitados:
 - CoreDNS para resolución DNS
 - kube-proxy para networking
 - vpc-cni para redes de pods
 - pod-identity-agent para autenticación

### Grupo de Nodos Inicial
- Tipo de instancia: t3.medium
- Capacidad: min 1, max 10 nodos
- Se ejecuta en subredes privadas
- Gestionado por EKS

### Karpenter Autoscaler
- Desplegado en namespace dedicado
- Configurado para usar AWS Pod Identity
- NodePool configurado para:
 - Instancias: t3.small, t3.medium, t3.large
 - Tipo de capacidad: bajo demanda
 - AMI: Amazon Linux 2023
 - Límite de CPU: 100
 - Consolidación automática cuando los nodos están vacíos

