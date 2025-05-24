# AWS VPC Endpoints con Terraform

[![Terraform](https://img.shields.io/badge/Terraform-1.0+-623CE4?logo=terraform&logoColor=white)](https://terraform.io)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazonaws&logoColor=white)](https://aws.amazon.com)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## Índice

- [Descripción General](#descripción-general)
- [Arquitectura](#arquitectura)
- [Comenzando](#comenzando)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Componentes](#componentes)
- [Configuración](#configuración)
- [Probando Conectividad](#probando-conectividad)
- [Optimización de Costos](#optimización-de-costos)
- [Características de Seguridad](#características-de-seguridad)
- [Arquitectura Modular](#arquitectura-modular)
- [Capturas de Pantalla](#capturas-de-pantalla)
- [Lecciones Aprendidas](#lecciones-aprendidas)
- [Recursos Adicionales](#recursos-adicionales)


## Descripción General

Este proyecto demuestra la implementación de AWS VPC Endpoints usando Terraform, mostrando tanto **Gateway Endpoints** (gratuitos) como **Interface Endpoints** (de pago) para habilitar conectividad privada entre instancias EC2 y servicios de AWS sin pasar por internet.

### Características Principales

- **Gateway VPC Endpoint** para S3 (económico, no requiere ENI)
- **Interface VPC Endpoint** para SSM (crea ENI, habilita DNS privado)
- **EC2 Instance Connect Endpoint** para acceso SSH seguro
- **Arquitectura de subnet privada** sin NAT Gateway
- **Código Terraform modular** usando módulos oficiales de AWS
- **Configuración organizada** en archivos separados por funcionalidad

## Arquitectura

## Comenzando

### Prerrequisitos

- AWS CLI configurado con permisos apropiados
- Terraform >= 1.0
- Un key pair existente de AWS para acceso EC2

### Despliegue Rápido

1. **Clonar el repositorio**
   ```bash
   git clone <repository-url>
   cd aws-vpc-endpoints-terraform
   ```

2. **Configurar variables**
   ```bash
   # Editar variables.tf o crear terraform.tfvars
   echo 'ec2_key_name = "tu-key-pair-name"' > terraform.tfvars
   ```

3. **Desplegar infraestructura**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Estructura del Proyecto

```
├── variables.tf            # Variables de configuración
├── locals.tf              # Variables locales y cálculos
├── providers.tf           # Configuración de Terraform y proveedores
├── data.tf                # Fuentes de datos de AWS
├── vpc.tf                 # VPC y configuración de red
├── security.tf            # Security Groups e IAM roles
├── compute.tf             # EC2 y recursos de cómputo
├── storage.tf             # S3 y almacenamiento
├── endpoints.tf           # VPC Endpoints (Gateway e Interface)
├── outputs.tf             # Valores de salida
├── user_data.sh           # Script de inicialización para EC2
├── README.md              # Este archivo
└── screenshots/           # Diagramas de arquitectura
    ├── vpc-endpoints.png
    ├── resource-map.png
    └── network-interfaces.png
```

## 🔧 Components

### VPC Endpoints

| Endpoint | Type | Service | Cost | Creates ENI |
|----------|------|---------|------|------------|
| S3 Gateway | Gateway | Amazon S3 | Free | No |
| SSM Interface | Interface | Systems Manager | $0.01/hour + data | Yes |

### Infrastructure Resources

- **VPC**: Custom VPC with DNS support enabled
- **Subnets**: 2 public + 2 private subnets across 2 AZs
- **EC2**: Amazon Linux 2 instance in private subnet
- **Security Groups**: Configured for SSH and HTTPS access
- **Instance Connect Endpoint**: For secure SSH access

## 🧪 Testing Connectivity

### 1. Connect to EC2 Instance
```bash
# Using EC2 Instance Connect
aws ec2-instance-connect ssh --instance-id i-xxxxxxxxx --os-user ec2-user
```

### 2. Test S3 Gateway Endpoint
```bash
# List S3 buckets (should work without internet access)
aws s3 ls
```

### 3. Test SSM Interface Endpoint
```bash
# Get AMI parameter from Systems Manager
aws ssm get-parameter --name "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"

# Verify private DNS resolution
nslookup ssm.us-east-1.amazonaws.com
# Should return private IP (10.x.x.x)
```

### 4. Verify No Internet Access
```bash
# This should fail (confirming no NAT Gateway)
curl -I https://google.com
```

##  Cost Optimization

### Gateway vs Interface Endpoints

**Gateway Endpoints (S3, DynamoDB)**
- ✅ **Cost**: $0.00 (completely free)
- ✅ **Data transfer**: No additional charges
- ❌ **Services**: Limited to S3 and DynamoDB only

**Interface Endpoints (All other services)**
- 💰 **Cost**: $0.01/hour per endpoint per AZ
- 💰 **Data transfer**: $0.01/GB processed
- ✅ **Services**: 100+ AWS services supported

### Monthly Cost Estimate
```
SSM Interface Endpoint: $0.01/hour × 24h × 30 days = $7.20/month
Data Transfer (estimated): $1-5/month
Total: ~$8-12/month per Interface endpoint
```

## Características de Seguridad

### Seguridad de Red
- **Subnets privadas**: Las instancias EC2 no tienen acceso directo a internet
- **Security groups**: Configurados con permisos mínimos requeridos
- **VPC endpoints**: Mantienen las llamadas API de AWS dentro de la red backbone de AWS
- **Sin NAT Gateway**: Elimina potencial vector de ataque

### Control de Acceso
- **Roles IAM**: La instancia EC2 usa rol IAM en lugar de access keys
- **Instance Connect**: Acceso SSH seguro sin bastion hosts
- **Políticas de endpoint**: Pueden restringir acceso a buckets S3 específicos

## Capturas de Pantalla

### Panel de VPC Endpoints
![VPC Endpoints](screenshots/vpc-endpoints.png)
*Muestra tanto Gateway (S3) como Interface (SSM) endpoints*

### Vista del Mapa de Recursos
![Resource Map](screenshots/resource-map.png)
*Representación visual de recursos VPC y conexiones*

### Interfaces de Red
![Network Interfaces](screenshots/network-interfaces.png)
*ENI creada por el endpoint Interface de SSM*

## Lecciones Aprendidas

### Gateway vs Interface Endpoints

| Aspecto | Gateway | Interface |
|---------|---------|-----------|
| **Flujo de Tráfico** | Route table → AWS backbone | Security Group → ENI → AWS |
| **Security Groups** | Se omiten | Se aplican y hacen cumplir |
| **Resolución DNS** | DNS público | DNS privado disponible |
| **Alta Disponibilidad** | Servicio regional | Despliegue por AZ |
| **Servicios** | Solo S3, DynamoDB | Más de 100 servicios AWS |

### Consideraciones de Security Group

- **Gateway endpoints** no requieren modificaciones de security group
- **Interface endpoints** requieren acceso HTTPS (puerto 443) saliente
- Siempre usar principios de acceso de menor privilegio

## Recursos Adicionales

- [Documentación AWS VPC Endpoints](https://docs.aws.amazon.com/vpc/latest/privatelink/)
- [Módulo Terraform AWS VPC](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
- [Precios AWS VPC Endpoint](https://aws.amazon.com/privatelink/pricing/)

## Limpieza

Para destruir todos los recursos:
```bash
terraform destroy
```

** Advertencia**: Esto eliminará permanentemente todos los recursos creados.

## Licencia

Este proyecto está licenciado bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## Contribuyendo

¡Las contribuciones son bienvenidas! Por favor, siéntete libre de enviar un Pull Request.

---

**Nota**: Este es un proyecto de demostración para aprender AWS VPC Endpoints. Asegúrate de entender las implicaciones de costo antes de desplegar en entornos de producción.
