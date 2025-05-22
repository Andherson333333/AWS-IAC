# AWS VPC Peering con EC2 Instance Connect Endpoints

## Índice

- [Descripción General](#descripción-general)
- [Características Principales](#características-principales)
- [Requisitos Previos](#requisitos-previos)
- [Instrucciones de Despliegue](#instrucciones-de-despliegue)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Validación y Pruebas](#validación-y-pruebas)
- [Procedimientos de Limpieza](#procedimientos-de-limpieza)
- [Consideraciones de Seguridad](#consideraciones-de-seguridad)
- [Referencias](#referencias)
- [Licencia](#licencia)

---

Una implementación integral con Terraform para establecer conectividad segura VPC-a-VPC utilizando AWS VPC Peering, complementada con EC2 Instance Connect Endpoints para acceso sin bastiones a instancias privadas.

## Descripción General

Este proyecto automatiza el despliegue de una arquitectura multi-VPC en AWS, demostrando patrones modernos de redes en la nube y mejores prácticas de seguridad. La infraestructura permite comunicación segura entre segmentos de red aislados mientras proporciona acceso administrativo a recursos privados sin servidores de salto tradicionales.

### Componentes de la Arquitectura

- **Configuración Dual de VPC**: Dos Virtual Private Clouds independientes con aislamiento completo de subredes
- **Conexión VPC Peering**: Ruta de comunicación directa y cifrada entre redes VPC
- **Instancias EC2 Privadas**: Recursos de cómputo desplegados en subredes privadas para seguridad mejorada
- **EC2 Instance Connect Endpoints**: Servicio administrado por AWS para acceso shell seguro sin exposición de IP pública
- **Infraestructura como Código**: Implementación completa en Terraform usando módulos validados por la comunidad

## Características Principales

### Implementación de VPC Peering
VPC Peering establece una conexión de red entre dos VPCs, permitiendo que los recursos se comuniquen usando direcciones IPv4 privadas. Esta implementación proporciona:

- **Ruta de Red Directa**: El tráfico fluye directamente entre VPCs sin atravesar internet gateway
- **Optimización de Costos**: Elimina requerimientos de NAT Gateway para comunicación inter-VPC
- **Seguridad Mejorada**: Todo el tráfico permanece dentro de la infraestructura backbone de AWS
- **Baja Latencia**: Ruta de enrutamiento directo minimiza saltos de red

### EC2 Instance Connect Endpoints
Los EC2 Instance Connect Endpoints representan el enfoque moderno de AWS para acceso seguro a instancias, ofreciendo:

- **Eliminación de Bastiones**: Conectividad directa a instancias privadas sin servidores de salto
- **Integración IAM**: Autenticación y autorización a través de sistemas de identidad AWS existentes
- **Infraestructura Administrada**: AWS maneja disponibilidad del endpoint y parches de seguridad
- **Rastro de Auditoría**: Logging completo de sesiones a través de integración CloudTrail

## Arquitectura de Infraestructura

![Diagrama de Arquitectura VPC Peering](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC-Peering-endpoint-ec2/Imagenes/vpc-peerin-7.png)

La arquitectura implementada muestra:
- **VPC-1** (10.1.0.0/16) y **VPC-2** (10.2.0.0/16) en la región us-east-1
- Subredes públicas y privadas distribuidas en zonas de disponibilidad us-east-1a y us-east-1b
- Instancias EC2 desplegadas en subredes privadas
- EC2 Instance Connect Endpoints para acceso seguro
- Conexión VPC Peering activa permitiendo comunicación directa entre VPCs

## Requisitos Previos

- **Terraform**: Versión 1.0 o superior
- **AWS CLI**: Configurado con credenciales apropiadas
- **Cuenta AWS**: Con permisos suficientes para operaciones VPC, EC2 y networking
- **Par de Claves SSH**: Par de claves preexistente en la región AWS objetivo

## Instrucciones de Despliegue

### Configuración Inicial

1. **Clonar el repositorio**
   ```bash
   git clone <repository-url>
   cd vpc-peering-terraform
   ```

2. **Configurar credenciales AWS**
   ```bash
   aws configure
   # o
   export AWS_PROFILE=tu-perfil
   ```

3. **Actualizar variables de configuración**
   
   Editar la configuración EC2 para especificar tu par de claves SSH:
   ```hcl
   # ec2.tf
   key_name = "nombre-de-tu-par-de-claves-existente"
   ```

### Despliegue de Infraestructura

1. **Inicializar workspace de Terraform**
   ```bash
   terraform init
   ```

2. **Revisar plan de despliegue**
   ```bash
   terraform plan
   ```

3. **Desplegar infraestructura**
   ```bash
   terraform apply
   ```

## Estructura del Proyecto

```
.
├── locals.tf               # Variables locales y configuración
├── providers.tf            # Configuración de providers y requerimientos
├── data.tf                 # Data sources para AMIs y zonas de disponibilidad
├── vpc.tf                  # Configuraciones de módulos VPC
├── vpc-peering.tf          # Configuración de conexión VPC peering
├── security-groups.tf      # Definiciones de security groups
├── ec2.tf                  # Configuraciones de instancias EC2
├── endpoint.tf             # EC2 Instance Connect Endpoints
├── outputs.tf              # Valores de salida para conectividad
└── README.md               # Esta documentación
```

## Validación y Pruebas

### Verificación de Infraestructura

Después del despliegue exitoso, verificar los siguientes componentes:

1. **Configuración VPC**
   
   ![Lista de VPCs](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC-Peering-endpoint-ec2/Imagenes/vpc-peerin-5.png)
   
   - Confirmar que dos VPCs están creadas con bloques CIDR correctos
   - Validar creación de subredes en múltiples zonas de disponibilidad
   - Verificar configuración de tablas de rutas para comunicación inter-VPC

2. **Estado VPC Peering**
   
   ![Conexión VPC Peering](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC-Peering-endpoint-ec2/Imagenes/vpc-peerin-6.png)
   
   - Asegurar que el estado de conexión peering muestra como "Active"
   - Confirmar propagación de rutas a tablas de rutas de ambas VPCs
   - Validar que reglas de security groups permiten tráfico requerido

3. **EC2 Instance Connect Endpoints**
   
   ![Instancias EC2](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC-Peering-endpoint-ec2/Imagenes/vpc-peerin-4.png)
   
   - Verificar que endpoints están en estado "Available"
   - Confirmar ubicación de endpoints en subredes privadas
   - Revisar configuraciones de security groups asociados

### Pruebas de Conectividad

#### Acceso SSH vía EC2 Instance Connect



#### Verificación de Conectividad Inter-VPC

![Detalles de Instancia VPC-2](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC-Peering-endpoint-ec2/Imagenes/vpc-peerin-4.png)

Desde la instancia conectada, probar conectividad de red:

![Prueba de Conectividad Ping](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC-Peering-endpoint-ec2/Imagenes/vpc-peerin-3.png)

![Prueba de Conectividad Ping](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC-Peering-endpoint-ec2/Imagenes/vpc-peerin-2.png)

Como se muestra en la captura, el ping exitoso desde la instancia en VPC-1 (10.1.10.7) hacia la instancia en VPC-2 (10.2.11.104) confirma que:
- La conexión VPC Peering está funcionando correctamente
- Las tablas de rutas están configuradas apropiadamente
- Los security groups permiten el tráfico ICMP entre VPCs
- La latencia promedio es inferior a 2ms, demostrando la eficiencia de la conexión directa


### Análisis de Red

Verificar configuración de enrutamiento usando AWS CLI:
```bash
# Listar tablas de rutas
aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$(terraform output -raw vpc_1_id)"

# Examinar conexión peering
aws ec2 describe-vpc-peering-connections --filters "Name=status-code,Values=active"
```

## Procedimientos de Limpieza

Para remover toda la infraestructura desplegada:
```bash
terraform destroy
```

## Consideraciones de Seguridad

- **Aislamiento de Red**: Recursos desplegados en subredes privadas sin acceso directo a internet
- **Control de Acceso**: Acceso SSH restringido a pares de claves autorizados
- **Cifrado**: Todo tráfico inter-VPC cifrado por defecto
- **Logging de Auditoría**: Sesiones EC2 Instance Connect registradas en CloudTrail
- **Principio de Menor Privilegio**: Security groups configurados con acceso mínimo requerido

## Referencias

- [Documentación AWS VPC Peering](https://docs.aws.amazon.com/vpc/latest/peering/)
- [Guía de Usuario EC2 Instance Connect Endpoint](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/connect-using-eice.html)
- [Documentación Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

## Licencia

Este proyecto está licenciado bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.
