## Índice de contenidos
* [Que es IAC ](#item1)
* [Que es cloudformation?](#item2)
* [Beneficios de AWS CloudFormation](#item3)
* [Conceptos clave de CloudFormation](#item4)
* [](#item5)

<a name="item1"></a>
## Que es IAC ?

  La Infraestructura como Código (IaC) es una práctica que consiste en gestionar y provisionar la infraestructura de TI utilizando archivos de código, en lugar de configuraciones manuales. Esto significa que en lugar de realizar tareas de forma manual a través de la consola de administración o interfaces gráficas, se define la infraestructura utilizando lenguajes de programación como YAML o JSON. Luego, herramientas como AWS CloudFormation interpretan estos archivos y crean o modifican los recursos de forma automática en la nube

<a name="item2"></a>
## Que es cloudformation?

  AWS CloudFormation es un servicio de AWS que permite definir y administrar la infraestructura de AWS como código, siguiendo el concepto de IaC. Con CloudFormation, puedes crear y actualizar recursos de forma automatizada y coherente, utilizando plantillas que describen la infraestructura que deseas implementar. Estas plantillas son archivos en formato YAML o JSON que contienen la configuración de los recursos, sus propiedades y relaciones entre ellos.

<a name="item3"></a>  
## Beneficios de AWS CloudFormation

- Automatización y consistencia: CloudFormation automatiza el despliegue y la gestión de recursos, garantizando una configuración consistente en todos los entornos.
- Versionado y control de cambios: Permite controlar y gestionar versiones de las plantillas, así como realizar seguimiento de los cambios en la infraestructura.
- Reutilización: Las plantillas pueden ser reutilizadas en diferentes entornos (desarrollo, pruebas, producción), lo que facilita la replicación de la infraestructura.
- Escalabilidad: Permite escalar la infraestructura de manera eficiente mediante la definición de recursos y sus configuraciones en las plantillas.
- Monitoreo simplificado: Facilita el monitoreo y la gestión de la infraestructura al centralizar la configuración en archivos de código.

<a name="item4"></a>
## Conceptos clave de CloudFormation

- Plantillas (Templates): Archivos en formato YAML o JSON que describen la infraestructura que se desea implementar.
Stacks: Instancias únicas de una plantilla. Cada vez que despliegas una plantilla, creas un stack.
- Recursos: Componentes individuales de la infraestructura, como instancias EC2, grupos de seguridad, etc.
Parámetros: Valores que se pueden pasar a la plantilla durante la creación del stack para personalizar la configuración.
- Salidas (Outputs): Valores generados por la plantilla que pueden ser útiles fuera del stack, como direcciones URL, IDs, etc.
- Referencias: Mecanismos para referenciar otros recursos dentro de la plantilla, estableciendo dependencias y relaciones.
- Update Policy: Políticas que definen cómo CloudFormation debe manejar actualizaciones en los recursos existentes.
- Rollback: Mecanismos para revertir un stack a su estado anterior en caso de fallos durante la actualización.

<a name="item5"></a>
## Como desplegar un stack en AWS 

- Paso 1: Preparación
- Paso 2: Crear una Plantilla (Template)
- Paso 3: Configurar el Stack
- Paso 4: Crear el Stack
- Paso 5: Gestión del Stack















