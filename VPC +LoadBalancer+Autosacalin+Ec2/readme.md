# Infraestructura de AWS con Terraform

Este proyecto utiliza Terraform para configurar una infraestructura escalable y altamente disponible en AWS. Incluye una VPC, subredes públicas y privadas, un Application Load Balancer y un Auto Scaling Group para instancias EC2.

## Índice de contenidos
* [Resumen de la arquitectura](#item1)
* [Requisitos previos](#item2)
* [Uso](#item3)
* [Configuración](#item4)
* [Componentes](#item5)
* [Seguridad](#item6)
* [Escalado](#item7)
* [Limpieza](#item8)

<a name="item1"></a>
## Resumen de la arquitectura
- VPC con subredes públicas y privadas en dos zonas de disponibilidad
- Internet Gateway para acceso a internet público
- NAT Gateway para acceso a internet saliente desde subredes privadas
- Application Load Balancer en subredes públicas
- Auto Scaling Group de instancias EC2 en subredes privadas
- Grupos de seguridad para el Load Balancer y las instancias EC2

<a name="item2"></a>
## Requisitos previos
- Cuenta de AWS
- Terraform instalado
- AWS CLI configurado con las credenciales apropiadas

<a name="item3"></a>
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

<a name="item4"></a>
## Configuración
Los parámetros principales de configuración se pueden ajustar en el archivo `variables.tf`:
- `public_subnet_cidrs`: Bloques CIDR para subredes públicas
- `private_subnet_cidrs`: Bloques CIDR para subredes privadas
- `azs`: Zonas de disponibilidad a utilizar
- `exposed_ports`: Puertos expuestos en el Load Balancer
- `exposed_ports_ec2`: Puertos expuestos en instancias EC2
- `ami`: ID de la AMI para instancias EC2
- `instance_type`: Tipo de instancia EC2

<a name="item5"></a>
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

<a name="item6"></a>
## Seguridad
- El Load Balancer es accesible desde internet en los puertos especificados
- Las instancias EC2 están en subredes privadas y solo son accesibles a través del Load Balancer
- El acceso a internet saliente para las instancias EC2 se proporciona a través del NAT Gateway

<a name="item7"></a>
## Escalado
El Auto Scaling Group está configurado para escalar basado en la utilización de CPU. La política de escalado apunta a una utilización del 50% de la CPU.

<a name="item8"></a>
## Limpieza
Para destruir los recursos creados:
```sh
terraform destroy
```
Nota: Esto eliminará permanentemente todos los recursos creados por esta configuración de Terraform. Usa con precaución.

