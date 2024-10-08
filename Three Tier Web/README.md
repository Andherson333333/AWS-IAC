# AWS TriTier: Infraestructura Web Escalable con Terraform

## Table of Contents
* [Descripción general de la arquitectura](#item1)
* [Descripción](#item2)
* [Componentes Principales](#item3)
* [Requisitos Previos](#item4)
* [Despliegue](#item5)

<a name="item1"></a>
## Descripción general de la arquitectura
![Diagrama de Arquitectura](https://github.com/aws-samples/aws-three-tier-web-architecture-workshop/blob/main/application-code/web-tier/src/assets/3TierArch.png)

Este proyecto implementa una arquitectura web de tres niveles en AWS utilizando Terraform. La arquitectura incluye un nivel web público, un nivel de aplicación privado y una base de datos Aurora MySQL.

<a name="item2"></a>
## Descripción
Esta arquitectura consta de:
- Un Balanceador de Carga de Aplicaciones (ALB) público que dirige el tráfico al nivel web.
- Servidores web Nginx en el nivel web que sirven una aplicación React.js y redirigen las llamadas API.
- Un ALB interno que dirige el tráfico al nivel de aplicación.
- Servidores de aplicación Node.js en el nivel de aplicación.
- Una base de datos Aurora MySQL multi-AZ.

<a name="item3"></a>
## Componentes Principales
- VPC con subredes públicas, privadas y de base de datos
- Grupos de seguridad para cada nivel
- Balanceadores de carga internos y externos
- Grupos de Auto Escalado para los niveles web y de aplicación
- Cluster de base de datos Aurora MySQL
- Roles y perfiles de instancia IAM

<a name="item4"></a>
## Requisitos Previos
- Cuenta de AWS
- Terraform instalado
- AWS CLI configurado

<a name="item5"></a>
## Despliegue
Para configurar las AMI se puede realizar con esta documentación: https://catalog.us-east-1.prod.workshops.aws/workshops/85cd2bb2-7f79-4e96-bdee-8078e469752a/en-US/part6/autoscaling

1. Configurar el App tier
   - Instalar cliente MySQL
   - Verificar el endpoint de RDS
   - Configurar el archivo Db.config.js en la ubicación /app-tier
   - Crear una AMI de la instancia

2. Configurar el Nginx
   - Verificar el loadbalancer interno
   - Configurar nginx
   - Verificar conexión
   - Crear una AMI de la instancia

3. Sustituir el AMI en el Terraform

4. Aplicar código Terraform
   - VPC
     ![Diagrama VPC](https://github.com/Andherson333333/AWS-IAC/blob/main/Three%20Tier%20Web/imagenes/project-T3-8.png)
   - Loadbalancer
     ![Diagrama Loadbalancer](https://github.com/Andherson333333/AWS-IAC/blob/main/Three%20Tier%20Web/imagenes/project-T3-6.png)
   - EC2
     ![Diagrama EC2](https://github.com/Andherson333333/AWS-IAC/blob/main/Three%20Tier%20Web/imagenes/project-T3-5.png)
   - RDS
     ![Diagrama RDS](https://github.com/Andherson333333/AWS-IAC/blob/main/Three%20Tier%20Web/imagenes/project-T3-7.png)
   - Web
     ![Diagrama Web](https://github.com/Andherson333333/AWS-IAC/blob/main/Three%20Tier%20Web/imagenes/project-T3-3.png)
   - Base de datos
     ![Diagrama Base de datos](https://github.com/Andherson333333/AWS-IAC/blob/main/Three%20Tier%20Web/imagenes/project-T3-4.png)
 
  

