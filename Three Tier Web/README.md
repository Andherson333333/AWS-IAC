# AWS TriTier: Infraestructura Web Escalable con Terraform

## Architecture Overview
![Architecture Diagram](https://github.com/aws-samples/aws-three-tier-web-architecture-workshop/blob/main/application-code/web-tier/src/assets/3TierArch.png)


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

## Despligue

Para configurar las ami se puede realizar con este documentacion https://catalog.us-east-1.prod.workshops.aws/workshops/85cd2bb2-7f79-4e96-bdee-8078e469752a/en-US/part6/autoscaling

- 1 Configurar el de App tier
    - Instalar mysql cliente configurar 
    - Verificar el endpoint de RDS
    - Cofigurar el arhcivo Db.config.js en la ubicacion /app-tier
    - Crear un ami de la instancia
      
- 2 Configurar el de Nginx
   - Verificar el loadbalancer interno
   - Configurar nginx
   - Verificar conecion
   - Crear un ami de la instancia
     
- 3 Sustituir el ami en el terrafomr
  
- 4 Aplicar terraform code
  - vpc
  - ![Architecture Diagram](https://github.com/Andherson333333/AWS-IAC/blob/main/Three%20Tier%20Web/imagenes/project-T3-8.png)
  - Loadbalancer
  - ![Architecture Diagram](https://github.com/Andherson333333/AWS-IAC/blob/main/Three%20Tier%20Web/imagenes/project-T3-6.png)
  - EC2
  - ![Architecture Diagram](https://github.com/Andherson333333/AWS-IAC/blob/main/Three%20Tier%20Web/imagenes/project-T3-5.png)
  - RDS 
    ![Architecture Diagram](https://github.com/Andherson333333/AWS-IAC/blob/main/Three%20Tier%20Web/imagenes/project-T3-7.png)
  - Web
![Architecture Diagram](https://github.com/Andherson333333/AWS-IAC/blob/main/Three%20Tier%20Web/imagenes/project-T3-3.png)

 ![Architecture Diagram](https://github.com/Andherson333333/AWS-IAC/blob/main/Three%20Tier%20Web/imagenes/project-T3-4.png)

 
  

