# Infraestructura de AWS con Terraform

## Índice de contenidos
* [Que es AWS ?](#item1)
* [Que es ec2?](#item2)
* [Tipos de instancias](#item3)
* [Formas de crear un EC2](#item4)
* [Paramentros principales de un ec2](#item5)
* [Creacion EC2 con Cloudformation](#item6)
* [Creacion EC2 con Terraform](#item7)

Este proyecto utiliza Terraform para configurar una infraestructura escalable y altamente disponible en AWS. Incluye una VPC, subredes públicas y privadas, un Application Load Balancer y un Auto Scaling Group para instancias EC2.

<a name="item1"></a>
## Que es AWS ?
[Contenido sobre AWS]

<a name="item2"></a>
## Que es ec2?
[Contenido sobre EC2]

<a name="item3"></a>
## Tipos de instancias
[Contenido sobre tipos de instancias]

<a name="item4"></a>
## Formas de crear un EC2
[Contenido sobre formas de crear EC2]

<a name="item5"></a>
## Paramentros principales de un ec2
[Contenido sobre parámetros principales de EC2]

<a name="item6"></a>
## Creacion EC2 con Cloudformation
[Contenido sobre creación de EC2 con CloudFormation]

<a name="item7"></a>
## Creacion EC2 con Terraform
[Contenido sobre creación de EC2 con Terraform]

## Resumen de la arquitectura
- VPC con subredes públicas y privadas en dos zonas de disponibilidad
- Internet Gateway para acceso a internet público
- NAT Gateway para acceso a internet saliente desde subredes privadas
- Application Load Balancer en subredes públicas
- Auto Scaling Group de instancias EC2 en subredes privadas
- Grupos de seguridad para el Load Balancer y las instancias EC2

## Requisitos previos
- Cuenta de AWS
- Terraform instalado
- AWS CLI configurado con las credenciales apropiadas

## Uso
1. Clona este repositorio
2. Navega al directorio del proyecto
3. Inicializa Terraform:
    ```sh
    terraform init
    ```
4. Revisa los cambios planificados:
    ```sh
    terraform plan
    ```
5. Aplica la configuración de Terraform:
    ```sh
    terraform apply
    ```

## Configuración
Los parámetros principales de configuración se pueden ajustar en el archivo `variables.tf`:
- `public_subnet_cidrs`: Bloques CIDR para subredes públicas
- `private_subnet_cidrs`: Bloques CIDR para subredes privadas
- `azs`: Zonas de disponibilidad a utilizar
- `exposed_ports`: Puertos expuestos en el Load Balancer
- `exposed_ports_ec2`: Puertos expuestos en instancias EC2
- `ami`: ID de la AMI para instancias EC2
- `instance_type`: Tipo de instancia EC2

## Componentes
- VPC
- Subredes públicas y privadas
- Internet Gateway
- NAT Gateway
- Tablas de rutas
- Grupos de seguridad
- Application Load Balancer
- Launch Configuration
- Auto Scaling Group
- Auto Scaling Policy

## Seguridad
- El Load Balancer es accesible desde internet en los puertos especificados
- Las instancias EC2 están en subredes privadas y solo son accesibles a través del Load Balancer
- El acceso a internet saliente para las instancias EC2 se proporciona a través del NAT Gateway

## Escalado
El Auto Scaling Group está configurado para escalar basado en la utilización de CPU. La política de escalado apunta a una utilización del 50% de la CPU.

## Limpieza
Para destruir los recursos creados:
    ```sh
    terraform destroy
    ```
Nota: Esto eliminará permanentemente todos los recursos creados por esta configuración de Terraform. Usa con precaución.
