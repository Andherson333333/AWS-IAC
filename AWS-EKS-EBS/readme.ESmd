# Configuración de Clúster EKS con Terraform

Este repositorio contiene archivos de configuración de Terraform para desplegar un clúster de Amazon EKS (Elastic Kubernetes Service) con almacenamiento persistente utilizando AWS EBS CSI Driver. Esta configuración proporciona una solución completa de almacenamiento para aplicaciones que requieren persistencia de datos en Kubernetes.

## AWS EBS (Elastic Block Store)

EBS es un servicio de almacenamiento en bloque de AWS diseñado para ser usado con Amazon EC2 y Amazon EKS. Es similar a un disco duro virtual en la nube.

## Descripción General de la Arquitectura

La configuración crea:
- Una VPC con subredes públicas, privadas e internas en 2 zonas de disponibilidad
- Un clúster EKS (versión 1.30) con grupos de nodos gestionados
- Integración del controlador AWS EBS CSI
- Configuración de clase de almacenamiento GP3 por defecto

## Requisitos

- Terraform >= 1.0
- AWS CLI configurado con credenciales apropiadas
- kubectl
- Helm >= 2.9.0

## Instalacion

1. Inicializar Terraform:
```
terraform init
```
2. Revisar los cambios planificados:
```
terraform plan
```
3. Aplicar la configuración:
```
terraform apply
```

## Verificacion

## Componentes de Infraestructura

### Configuración de VPC

* CIDR: 10.0.0.0/16
* 2 Zonas de Disponibilidad
* Subredes Públicas, Privadas e Internas
* NAT Gateway habilitado
* Nombres de host DNS y soporte habilitados

### Clúster EKS

* Versión de Kubernetes: 1.30
* Acceso al endpoint público habilitado
* IRSA (IAM Roles for Service Accounts) habilitado
* Configuración del grupo de nodos gestionados:
  * Tipo de instancia: t3.medium
  * Tamaño mínimo: 1
  * Tamaño máximo: 10
  * Tamaño deseado: 1

### Complementos

* CoreDNS
* Agente de Identidad de Pod EKS
* Kube Proxy
* VPC CNI
* Controlador AWS EBS CSI

### Almacenamiento

* StorageClass por defecto: gp3-default
* Integración del controlador EBS CSI
* Volúmenes cifrados por defecto
* Modo de vinculación de volumen WaitForFirstConsumer


