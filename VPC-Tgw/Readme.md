# Configuración Full Mesh con AWS Transit Gateway

![Terraform](https://img.shields.io/badge/terraform-1.0+-623CE4?style=flat&logo=terraform)
![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?style=flat&logo=amazonaws)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

## Índice

- [Descripción General](#descripción-general)
- [Arquitectura](#arquitectura)
- [Inicio Rápido](#inicio-rápido)
- [Configuración de Red](#configuración-de-red)
  - [Bloques CIDR de VPC](#bloques-cidr-de-vpc)
  - [Transit Gateway](#transit-gateway)
- [Prueba de Conectividad](#prueba-de-conectividad)
- [Estructura de Archivos](#estructura-de-archivos)
- [Requisitos](#requisitos)
- [Validación](#validación)
- [Configuración del Transit Gateway](#configuración-del-transit-gateway)
- [Propagación de Rutas](#propagación-de-rutas)
- [Licencia](#licencia)
- [Soporte](#soporte)

## Descripción General

Este proyecto implementa una arquitectura de red Full Mesh utilizando AWS Transit Gateway (TGW) para conectar múltiples VPCs, permitiendo comunicación completa entre todas las VPCs sin necesidad de conexiones de peering individuales.

## Arquitectura

![Diagrama de Arquitectura](docs/images/architecture-diagram.png)

La solución despliega:
- 3 VPCs con subredes públicas y privadas
- 1 Transit Gateway como hub central
- Configuración Full Mesh automática mediante propagación de rutas
- Enrutamiento dinámico en las tablas de rutas privadas

## Inicio Rápido

 Inicializar Terraform
```
terraform init
```
 Revisar plan de ejecución
```
terraform plan
```
 Aplicar configuración
```
terraform apply
```

## Configuración de Red

### Bloques CIDR de VPC
- VPC-1: `10.1.0.0/16`
- VPC-2: `10.2.0.0/16`
- VPC-3: `10.3.0.0/16`

### Transit Gateway
- Propagación automática de rutas habilitada
- Soporte DNS habilitado
- Asociación de tabla de rutas por defecto

![Tablas de Rutas VPC](docs/images/vpc-route-tables.png)

## Prueba de Conectividad

![Prueba de Conectividad](docs/images/connectivity-test.png)

Ejemplo de conectividad exitosa entre VPCs:
- Origen: Instancia EC2 en VPC-1 (10.1.7.93)
- Destino: Instancia EC2 en VPC-3 (10.3.2.248)
- Resultado: Conectividad exitosa con latencia ~1ms

## Estructura de Archivos

```
vpc-tgw/
├── main.tf              # Configuración principal con VPCs y variables locales
├── tgw.tf               # Módulo Transit Gateway con attachments
├── tgw-rt-private.tf    # Configuración dinámica de rutas privadas
├── README.md            # Este archivo

```

## Requisitos

- Terraform >= 1.0
- AWS CLI configurado
- Permisos IAM para recursos VPC y Transit Gateway

## Validación

Verificar estado del Transit Gateway:
```bash
aws ec2 describe-transit-gateways --transit-gateway-ids <tgw-id>
```

Verificar tablas de rutas:
```bash
aws ec2 describe-route-tables --filters "Name=route.transit-gateway-id,Values=<tgw-id>"
```

## Configuración del Transit Gateway

![Detalles del Transit Gateway](docs/images/tgw-details.png)

El Transit Gateway utiliza:
- Tabla de rutas por defecto para todos los attachments
- Asociación y propagación automática
- Attachments multi-AZ para alta disponibilidad

## Propagación de Rutas

![Propagación de Rutas](docs/images/route-propagation.png)

Las rutas se propagan automáticamente entre todas las VPCs a través de la tabla de rutas por defecto del Transit Gateway.

## Licencia

Licencia MIT - ver archivo LICENSE para más detalles

## Soporte

- Abrir un issue en GitHub
- Consultar la [documentación de AWS Transit Gateway](https://docs.aws.amazon.com/es_es/vpc/latest/tgw/)
- Revisar la [documentación de módulos Terraform AWS](https://registry.terraform.io/modules/terraform-aws-modules/transit-gateway/aws/latest)
