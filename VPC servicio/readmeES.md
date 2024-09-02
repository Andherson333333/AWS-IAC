# Entendiendo y Creando una VPC en AWS

## Índice de contenidos
* [Que es una VPC ?](#item1)
* [Ventajas y desventajas](#item2)
* [Componentes principales VPC](#item3)
* [Creacion de una VPC](#item4)
* [Creacion Interfaz Grafica](#item5)
* [Creacion con IAC (Terraform y CloudFormation)](#item6)

<a name="item1"></a>
## Que es una VPC ?
Una VPC es una red virtual que creas en la nube. Te permite tener tu propia sección privada de Internet, como tener tu propia red dentro de una red más grande. Dentro de esta VPC, puedes crear y gestionar diversos recursos, como servidores, bases de datos y almacenamiento.

Esta red virtual está completamente aislada de las redes de otros usuarios, por lo que tus datos y aplicaciones están seguros y protegidos.

Con una VPC, tienes control sobre tu entorno de red. Puedes definir reglas de acceso, configurar firewalls y establecer grupos de seguridad para regular quién puede acceder a tus recursos y cómo pueden comunicarse.

<a name="item2"></a>
## Ventajas y desventajas
| Ventajas de una VPC                  | Desventajas de una VPC                       |
|--------------------------------------|----------------------------------------------|
| 1. Seguridad Mejorada                | 1. Configuración Compleja                    |
| 2. Control Total sobre la Red         | 2. Costos Adicionales                        |
| 3. Escalabilidad                     | 3. Posible Riesgo de Errores                 |
| 4. Mayor Disponibilidad              | 4. Dependencia de la Conexión a Internet     |
| 5. Integración con Servicios en la Nube | 5. Requerimientos de Conocimientos Específicos |
| 6. Costos Controlados                | 6. Posibles Limitaciones de Recursos         |

<a name="item3"></a>
## Componentes principales VPC
- 1-VPC
- 2-Subnets
- 3-IP addressing
- 4-Network Access Control List (NACL)
- 5-Security Group
- 6-Routing
- 7-Gateways and endpoints
- 8-Peering connections
- 9-Traffic Mirroring
- 10-VPC Flow Logs
- 11-VPN connections

<a name="item4"></a>
## Creacion de una VPC
Para crear una vpc se puede realizar con varios metodos :
- GUI (Interfaz grafica)
- CLI (Interfaz de Línea de Comandos)
- SDk (Kit de Desarrollo de Software)
- IAC (Infraestructura como Código)

<a name="item5"></a>
## Creacion Interfaz Grafica
1) Service - VPC
2) Create VPC (colocar el rango CIDR IP)
3) Crear Subred VPC (Esto ayuda a crear redundancia, una subred por cada zona recomendada)
4) Crear ACL (Al crear la subred se crea una por defecto para cada subred)
5) Crear tabla de ruteo (Se crea una tabla por defecto principal para comunicar mi VPC internamente sin acceso a internet)
6) Crear Internet Gateway (Se encarga de darle acceso a internet a mi VPC, es mi puerta de salida)
7) Crear tabla de ruteo (asociada al Internet Gateway)

<a name="item6"></a>
## Creacion con IAC (Terraform y CloudFormation)
En este caso se va a crear con IAC con 2 herramientas que son Terraform y CloudFormation. Esta VPC contendrá los siguientes componentes:
- 1-VPC
- 2-Subnets
- 3-IP addressing
- 4-Network Access Control List (NACL)
- 5-Security Group
- 6-Routing
- 7-Gateways

El código está dividido de la siguiente manera:
- 1 Terraform-code1: contendrá código Terraform pero sin módulos con un solo archivo main
- 2 Terraform-code2: contendrá código pero en forma de módulos
- 3 CloudFormation: contendrá 1 stack

Las 3 configuraciones hacen lo mismo solo de diferente manera.

![Diagrama](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC%20servicio/imagenes/vpc.png)




