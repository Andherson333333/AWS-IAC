# Proyecto de Despliegue de Lambda

Este proyecto demuestra cómo desplegar una función AWS Lambda utilizando tanto Terraform como CloudFormation. Incluye ejemplos de despliegue serverless y creación básica de funciones Lambda.

## Tabla de Contenidos

- [Visión General](#visión-general)
- [Serverless y Lambda](#serverless-y-lambda)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Despliegue con Terraform](#despliegue-con-terraform)
- [Despliegue con CloudFormation](#despliegue-con-cloudformation)
- [Comenzando](#comenzando)

## Visión General

Este repositorio contiene código y archivos de configuración para desplegar una función AWS Lambda simple utilizando dos herramientas diferentes de Infraestructura como Código (IaC): Terraform y CloudFormation.

## Serverless y Lambda

### ¿Qué es Serverless?

Serverless es un modelo de ejecución en la nube donde el proveedor de la nube gestiona automáticamente la infraestructura necesaria para ejecutar el código. No necesitas crear, gestionar o escalar servidores, instancias EC2 o contenedores. En su lugar, el código se ejecuta en respuesta a eventos específicos y solo mientras dure la ejecución, lo que permite una gestión eficiente y escalabilidad automática.

### ¿Qué es Lambda?

AWS Lambda es un servicio de computación serverless que ejecuta tu código en respuesta a eventos y gestiona automáticamente los recursos de computación subyacentes por ti. Puedes usar Lambda para extender otros servicios de AWS con lógica personalizada, o crear tus propios servicios backend que operen a escala, rendimiento y seguridad de AWS.

## Estructura del Proyecto

terraform-code1
```
.
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── terraform.tfvars
```

terrafomr-code2
```
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   └── indes.
```

## Despliegue con Terraform

Nota: Hay 2 codigo de terraform 
- terraform-code1 : ejecuta codigo del lambda dentro de terraform
- terraform-code2 : ejecuta el codigo a traves de un archivo zip

El directorio `terraform/` contiene archivos de configuración de Terraform para desplegar la función Lambda:

- `main.tf`: Contiene la configuración principal de Terraform para crear la función Lambda y el rol IAM.
- `variables.tf`: Define las variables de entrada para la configuración de Terraform.
- `terraform.tfvars`: Establece los valores para las variables definidas.

Nota: Al desplegar lambda se creara sin un evnto , eso quiere decir que el evnto se tiene que crear de forma manual

2. Para desplegar usando Terraform:
   ```
   cd terraform
   terraform init
   terraform plan
   terraform apply
   ```

![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWS%20lambda%20service/imagenes/lambda-1.png)

## Despliegue con CloudFormation

El directorio `Cloudformation-code/` contiene una plantilla de CloudFormation para desplegar la función Lambda:

- `stack.yml`: Plantilla de CloudFormation que define la función Lambda y el rol IAM.
