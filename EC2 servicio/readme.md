## Índice de contenidos
* [Que es AWS ?](#item1)
* [Que es ec2?](#item2)
* [Tipos de instancias](#item3)
* [Formas de crear un EC2](#item4)
* [Paramentros principales de un ec2](#item5)
* [Creacion EC2 con Cloudformation](#item6)
* [Creacion EC2 con Terraform](#item7)

<a name="item1"></a>
## Que es AWS ?

AWS (Amazon Web Services) es una plataforma de servicios en la nube ofrecida por Amazon. Proporciona una amplia gama de servicios de computación, almacenamiento, bases de datos, análisis, aprendizaje automático, inteligencia artificial, IoT (Internet de las cosas), seguridad, entre otros.

<a name="item2"></a>
## Que es ec2?

  EC2 (Elastic Compute Cloud) es un servicio de computación en la nube que proporciona capacidad informática escalable en la nube. Permite a los usuarios ejecutar máquinas virtuales (instancias) en la infraestructura de AWS. Estas instancias pueden ser configuradas con diversos sistemas operativos, tamaños de CPU, memoria, almacenamiento y otros recursos según las necesidades del usuario.

<a name="item3"></a>
## Tipos de instancias
Hay muchos tipos de instancia ec2 variando diferentes componentes como red,cpu,memoria,storage ect dependiendo la variacion cambiara sus nombres . Si necesitas servidores basados en memoria tiene un nombre , si necesitas red tiene otro nombre, tambien hay servidores equilibrado ect .

- `T2:`	General Purpose (Propósito General)	Desarrollo, pruebas, pequeñas cargas de trabajo
- `C5:`	Compute Optimized (Optimizado para Cómputo)	Análisis de datos, procesamiento por lotes
- `R5:`	Memory Optimized (Optimizado para Memoria)	Bases de datos en memoria, análisis de datos
- `I3:`	Storage Optimized (Optimizado para Almacenamiento)	Bases de datos NoSQL, análisis intensivos en disco
- `P3:`	Accelerated Computing (Cómputo Acelerado)	Modelado 3D, aprendizaje profundo (deep learning)
- `H1:`	Storage Optimized (Optimizado para Almacenamiento)	Procesamiento de datos en paralelo, análisis de registros

<a name="item4"></a>
## Formas de crear un EC2

Se puede desplega un ec2 de varios metodos esto son :

- `Interfaz web (GUI):`Accedes a la consola de AWS a través de un navegador web
- `Terraform :` herramienta de infraestructura como código (IaC) que te permite definir y gestionar la infraestructura de AWS de manera declarativa
- `Cloudformation :` Permite crear y gestionar recursos de manera automatizada utilizando plantillas de infraestructura
- `SDK:` (Software Development Kit): AWS proporciona SDKs para varios lenguajes de programación, como Python, Java, Node.js, etc.

<a name="item5"></a>
## Paramentros principales de un ec2

- image-id 
- instance-type
- key-name
- security-group-ids
- subnet-id

<a name="item6"></a>
## Creacion EC2 con Cloudformation

- 1 Crear archivo formato yaml o json
- 2 Ir a la documentacion AWS cloudformation https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-instance.html
- 3 Verificar los parametros para crear un instancia ec2
- 4 Crear un stack y subir el archivo yaml creado

<a name="item7"></a>
## Creacion EC2 con Terraform

- 1 Crear la estructura de archivos (generlamente esta compuesto por 4 archivos minimo base )
  - `provider.tf ` Este archivo se utiliza para especificar el proveedor de servicios cloud que se está utilizando
  - `main.tf` Este es el archivo principal donde se define la mayoría de los recursos.
  - `outputs.tf` Este archivo se utiliza para definir las salidas que se mostrarán después de que Terraform haya aplicado los cambios
  - `variables.tf` Este archivo se utiliza para definir las variables que se utilizarán en el archivo main.t
 
- 2 Crear archivos que termine .tf
- 3 Implementar codigo 
- 4 Desplegar (se usan los siguientes comandos:)
  
- `terraform init`
  
![Diagrama](https://github.com/Andherson333333/AWS-IAC/blob/main/EC2%20servicio/imagenes/terrafomr-2.PNG)

- `terraform plan`
  
![Diagrama](https://github.com/Andherson333333/AWS-IAC/blob/main/EC2%20servicio/imagenes/terrafomr-3.PNG)

- `terraform apply`
  
![Diagrama](https://github.com/Andherson333333/AWS-IAC/blob/main/EC2%20servicio/imagenes/terrafomr-4.PNG)

![Diagrama](https://github.com/Andherson333333/AWS-IAC/blob/main/EC2%20servicio/imagenes/terrafomr-5.PNG)

 - `terraform destroy`
![Diagrama]()
    
