# AWS TriTier: Infraestructura Web Escalable con Terraform

Este proyecto implementa una arquitectura web de tres niveles en AWS utilizando Terraform. La arquitectura incluye un nivel web público, un nivel de aplicación privado y una base de datos Aurora MySQL.

## Descripción

Esta arquitectura consta de:
- Un Balanceador de Carga de Aplicaciones (ALB) público que dirige el tráfico al nivel web.
- Servidores web Nginx en el nivel web que sirven una aplicación React.js y redirigen las llamadas API.
- Un ALB interno que dirige el tráfico al nivel de aplicación.
- Servidores de aplicación Node.js en el nivel de aplicación.
- Una base de datos Aurora MySQL multi-AZ.

## Componentes Principales

- VPC con subredes públicas, privadas y de base de datos
- Grupos de seguridad para cada nivel
- Balanceadores de carga internos y externos
- Grupos de Auto Escalado para los niveles web y de aplicación
- Cluster de base de datos Aurora MySQL
- Roles y perfiles de instancia IAM

## Requisitos Previos

- Cuenta de AWS
- Terraform instalado
- AWS CLI configurado


