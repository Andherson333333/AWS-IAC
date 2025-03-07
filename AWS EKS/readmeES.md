# AWS EKS con Terraform

Este repositorio contiene recursos para implementar Amazon Elastic Kubernetes Service (EKS) mediante Terraform, con dos enfoques diferentes.

## Contenido del Repositorio

- **[terraform-code1](./terraform-code1)**: Implementación de EKS utilizando módulos de Terraform.
- **[terraform-code2](./terraform-code2)**: Implementación de EKS sin utilizar módulos (recursos nativos).
- **[Documentación General de EKS](./docs/EKS-overview.md)**: Conceptos fundamentales de EKS.

## Estructura del Proyecto

```
AWS EKS/
│
├── terraform-code1/               # Implementación usando módulos de Terraform
│   ├── data.tf                    # Data sources (zonas de disponibilidad)
│   ├── eks.tf                     # Configuración del módulo EKS
│   ├── local.tf                   # Variables locales (región, nombre, etc.)
│   ├── provider.tf                # Configuración de proveedores
│   ├── readme.md                  # Documentación específica
│   └── vpc.tf                     # Configuración del módulo VPC
│
├── terraform-code2/               # Implementación sin usar módulos
│   ├── eks.tf                     # Recursos nativos para el cluster EKS
│   ├── local.tf                   # Variables locales
│   ├── node-eks.tf                # Configuración de nodos trabajadores
│   ├── provider.tf                # Configuración de proveedores
│   ├── readme.md                  # Documentación específica
│   └── vpc.tf                     # Recursos nativos para VPC
│
├── docs/                          # Documentación general
│   └── EKS-overview.md            # Conceptos fundamentales de EKS
│
├── imagenes/                      # Imágenes para la documentación
│   └── txt                        # Placeholder
│
├── readme.md                      # Este archivo (versión en inglés)
└── readmeES.md                    # Versión en español
```

## ¿Qué es Amazon EKS?

Amazon Elastic Kubernetes Service (EKS) es un servicio gestionado de AWS que facilita la ejecución de Kubernetes sin necesidad de instalar y mantener tu propio plano de control. [Leer más sobre EKS →](./docs/EKS-overview.md)

## Enfoques de Implementación

Este repositorio ofrece dos enfoques diferentes para implementar EKS:

### Enfoque 1: Usando Módulos de Terraform (terraform-code1)

- **Ventajas**: Código más conciso, mantenimiento más sencillo, implementación rápida
- **Caso de uso ideal**: Equipos que necesitan desplegar rápidamente un cluster EKS estándar
- **[Ver implementación →](./terraform-code1)**

### Enfoque 2: Sin Módulos (terraform-code2)

- **Ventajas**: Control granular, mayor personalización, comprensión detallada de los recursos
- **Caso de uso ideal**: Equipos que necesitan alta personalización o aprender sobre EKS
- **[Ver implementación →](./terraform-code2)**

## Documentación Disponible

- [Conceptos fundamentales de EKS](./docs/EKS-overview.md)
- [Guía de despliegue con módulos](./terraform-code1/README.md)
- [Guía de despliegue sin módulos](./terraform-code2/README.md)

## Requisitos Generales

- AWS CLI configurado
- Terraform ≥ 1.0
- Conocimientos básicos de Kubernetes

## Idiomas

- [English](./readme.md)
- [Español](./readmeES.md)





