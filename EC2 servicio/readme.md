# Infraestructura de AWS con Terraform

Este proyecto utiliza Terraform para configurar una infraestructura escalable y altamente disponible en AWS. Incluye una VPC, subredes públicas y privadas, un Application Load Balancer y un Auto Scaling Group para instancias EC2.

## Índice de contenidos
- [¿Qué es AWS?](#qué-es-aws)
- [¿Qué es EC2?](#qué-es-ec2)
- [Tipos de instancias](#tipos-de-instancias)
- [Formas de crear un EC2](#formas-de-crear-un-ec2)
- [Parámetros principales de un EC2](#parámetros-principales-de-un-ec2)
- [Creación de EC2 con CloudFormation](#creación-de-ec2-con-cloudformation)
- [Creación de EC2 con Terraform](#creación-de-ec2-con-terraform)

## ¿Qué es AWS?

AWS (Amazon Web Services) es una plataforma de servicios en la nube ofrecida por Amazon. Proporciona una amplia gama de servicios de computación, almacenamiento, bases de datos, análisis, aprendizaje automático, inteligencia artificial, IoT (Internet de las cosas), seguridad, entre otros.

## ¿Qué es EC2?

EC2 (Elastic Compute Cloud) es un servicio de computación en la nube que proporciona capacidad informática escalable en la nube. Permite a los usuarios ejecutar máquinas virtuales (instancias) en la infraestructura de AWS. Estas instancias pueden ser configuradas con diversos sistemas operativos, tamaños de CPU, memoria, almacenamiento y otros recursos según las necesidades del usuario.

## Tipos de instancias

Hay muchos tipos de instancia EC2 que varían en diferentes componentes como red, CPU, memoria, almacenamiento, etc. Dependiendo de la variación, cambiará su nombre:

- `T2`: General Purpose (Propósito General) - Desarrollo, pruebas, pequeñas cargas de trabajo
- `C5`: Compute Optimized (Optimizado para Cómputo) - Análisis de datos, procesamiento por lotes
- `R5`: Memory Optimized (Optimizado para Memoria) - Bases de datos en memoria, análisis de datos
- `I3`: Storage Optimized (Optimizado para Almacenamiento) - Bases de datos NoSQL, análisis intensivos en disco
- `P3`: Accelerated Computing (Cómputo Acelerado) - Modelado 3D, aprendizaje profundo (deep learning)
- `H1`: Storage Optimized (Optimizado para Almacenamiento) - Procesamiento de datos en paralelo, análisis de registros

## Formas de crear un EC2

Se puede desplegar un EC2 de varios métodos:

- **Interfaz web (GUI)**: Accedes a la consola de AWS a través de un navegador web
- **Terraform**: Herramienta de infraestructura como código (IaC) que te permite definir y gestionar la infraestructura de AWS de manera declarativa
- **CloudFormation**: Permite crear y gestionar recursos de manera automatizada utilizando plantillas de infraestructura
- **SDK** (Software Development Kit): AWS proporciona SDKs para varios lenguajes de programación, como Python, Java, Node.js, etc.

## Parámetros principales de un EC2

- `image-id`
- `instance-type`
- `key-name`
- `security-group-ids`
- `subnet-id`

## Creación de EC2 con CloudFormation

1. Crear archivo en formato YAML o JSON
2. Ir a la documentación AWS CloudFormation: [https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-instance.html](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-instance.html)
3. Verificar los parámetros para crear una instancia EC2
4. Crear un stack y subir el archivo YAML creado

![CloudFormation 1](https://github.com/Andherson333333/AWS-IAC/blob/main/EC2%20servicio/imagenes/cloudfmation-1.PNG)
![CloudFormation 2](https://github.com/Andherson333333/AWS-IAC/blob/main/EC2%20servicio/imagenes/cloudfmation-2.PNG)
![CloudFormation 3](https://github.com/Andherson333333/AWS-IAC/blob/main/EC2%20servicio/imagenes/cloudfmation-3.PNG)

## Creación de EC2 con Terraform

1. Crear la estructura de archivos (generalmente está compuesta por 4 archivos mínimo base):
   - `provider.tf`: Este archivo se utiliza para especificar el proveedor de servicios cloud que se está utilizando
   - `main.tf`: Este es el archivo principal donde se define la mayoría de los recursos
   - `outputs.tf`: Este archivo se utiliza para definir las salidas que se mostrarán después de que Terraform haya aplicado los cambios
   - `variables.tf`: Este archivo se utiliza para definir las variables que se utilizarán en el archivo main.tf

2. Crear archivos que terminen en `.tf`

![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/EC2%20servicio/imagenes/terrafomr-1.PNG)

3. Implementar código
4. Desplegar (se usan los siguientes comandos):

- `terraform init`

![Terraform 2](https://github.com/Andherson333333/AWS-IAC/blob/main/EC2%20servicio/imagenes/terrafomr-2.PNG)

- `terraform plan`

![Terraform 3](https://github.com/Andherson333333/AWS-IAC/blob/main/EC2%20servicio/imagenes/terrafomr-3.PNG)

- `terraform apply`

![Terraform 4](https://github.com/Andherson333333/AWS-IAC/blob/main/EC2%20servicio/imagenes/terrafomr-4.PNG)
![Terraform 5](https://github.com/Andherson333333/AWS-IAC/blob/main/EC2%20servicio/imagenes/terrafomr-5.PNG)

- `terraform destroy`
