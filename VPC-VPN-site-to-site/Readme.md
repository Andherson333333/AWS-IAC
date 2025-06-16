# AWS Site-to-Site VPN con Terraform y Libreswan

Una implementación lista para producción de AWS Site-to-Site VPN utilizando Terraform para la automatización de infraestructura y Libreswan como Customer Gateway. Esta configuración demuestra cómo conectar redes on-premises de forma segura a AWS VPC utilizando túneles IPSec.

## Arquitectura
![vpn-conect](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC-VPN-site-to-site/imagenes/vpn-site-to-site-6.png)
## Características

- **Infraestructura como Código** con módulos de Terraform
- **Alta Disponibilidad** con túneles IPSec duales
- **Enrutamiento Estático** configurado
- **Security Groups** automatizados
- **Documentación completa** y guías de resolución de problemas
- **Asignación de recursos optimizada** en costos

## Prerrequisitos

### Software Requerido
- [Terraform](https://terraform.io/downloads) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configurado con permisos apropiados
- Acceso SSH a instancia EC2 Ubuntu

### Permisos AWS
Sus credenciales AWS necesitan permisos para:
- VPC, Subnets, Route Tables
- Instancias EC2 y Security Groups
- VPN Gateway y Customer Gateway
- Conexiones Site-to-Site VPN

### Requisitos de Red
- Dirección IP pública para Customer Gateway
- Par de claves EC2 en la región objetivo

### 2. Actualizar Configuración

Editar `customer-gateway-resource.tf` variables:

```hcl
# Actualizar IP pública de tu Customer Gateway
resource "aws_customer_gateway" "vyos_lab" {
  ip_address = "TU_IP_PUBLICA_AQUI"  # ← Cambiar esto
}

# Actualizar par de claves EC2
module "ec2_test_server" {
  key_name = "NOMBRE_DE_TU_KEY_PAIR"     # ← Cambiar esto
}
```
Revisar las otra parte para editar con la informacion necesaria 

### 3. Desplegar Infraestructura

```bash
# Inicializar Terraform
terraform init

# Planificar despliegue
terraform plan

# Aplicar configuración
terraform apply
```

### 4. Obtener Configuración VPN

```bash
# Mostrar detalles de conexión VPN
terraform output vpn_connection_info

# Obtener Pre-Shared Keys
terraform output useful_commands
```

## Configuración de Libreswan

### 1. Conectar al Customer Gateway

```bash
ssh -i tu-clave.pem ubuntu@TU_IP_PUBLICA
```

### 2. Instalar y Configurar Libreswan

```bash
# Instalar Libreswan
sudo apt update && sudo apt install libreswan -y

# Habilitar reenvío IP
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.ipv4.conf.all.accept_redirects=0
sudo sysctl -w net.ipv4.conf.all.send_redirects=0

# Hacer configuración permanente
cat << EOF | sudo tee -a /etc/sysctl.conf
net.ipv4.ip_forward = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
EOF
```

### 3. Configurar Túnel VPN

Crear `/etc/ipsec.d/aws-vpn.conf`:

```bash
conn Tunnel1
    authby=secret
    auto=start
    left=%defaultroute
    leftid=TU_IP_PUBLICA
    right=IP_TUNEL_AWS
    type=tunnel
    ikelifetime=8h
    keylife=1h
    keyexchange=ike
    leftsubnet=172.31.0.0/16
    rightsubnet=10.1.0.0/16
    dpddelay=10
    dpdtimeout=30
    dpdaction=restart_by_peer
```

Crear `/etc/ipsec.d/aws-vpn.secrets`:

```bash
TU_IP_PUBLICA IP_TUNEL_AWS: PSK "TU_PRE_SHARED_KEY"
```

### 4. Iniciar Servicio VPN

```bash
sudo systemctl enable ipsec
sudo systemctl start ipsec
sudo systemctl status ipsec
```

## Verificación

### 1. Verificar Propagación de Rutas

Verificar que las rutas VGW se propagan correctamente a las tablas de enrutamiento privadas:

**Verificación CLI:**
```bash
aws ec2 describe-route-tables --query 'RouteTables[*].Routes[?VpcPeeringConnectionId==null]'
```

![Salida CLI de Route Tables](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC-VPN-site-to-site/imagenes/vpn-site-to-site-5.png)

**Verificación Consola AWS:**
- Navegar a **VPC** → **Route Tables**
- Seleccionar tablas de enrutamiento privadas
- Verificar que la ruta `172.31.0.0/16` apunte al VGW con **Propagated = Yes**

![Route Table GUI - us-east-1a](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC-VPN-site-to-site/imagenes/vpn-site-to-site-3.png)
![Route Table GUI - us-east-1b](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC-VPN-site-to-site/imagenes/vpn-site-to-site-4.png)

### 2. Verificar Estado del Túnel VPN

**Consola AWS:**
1. Navegar a **VPC** → **Site-to-Site VPN Connections**
2. Verificar que al menos un **Tunnel Status** = **UP**
3. Verificar que **Customer Gateway Address** coincida con tu IP pública

![Estado de Conexión VPN](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC-VPN-site-to-site/imagenes/vpn-site-to-site-2.png)

### 3. Probar Conectividad End-to-End

**Desde Customer Gateway a Instancia Privada:**
```bash
ping 10.1.1.232
```

![Prueba de Ping Exitosa](https://github.com/Andherson333333/AWS-IAC/blob/main/VPC-VPN-site-to-site/imagenes/vpn-site-to-site-1.png)

### 4. Verificar Estado de Libreswan

```bash
# Verificar estado IPSec
sudo ipsec status

# Verificar flujo de tráfico
sudo ipsec trafficstatus

# Verificar políticas XFRM
sudo ip xfrm policy
sudo ip xfrm state
```

### 5. Verificación de Interfaces de Red

```bash
# Verificar tabla de enrutamiento
ip route show | grep 10.1

# Verificar interfaces de red
ip addr show
```

## Componentes de Infraestructura

| Recurso | Cantidad | Propósito |
|---------|----------|----------|
| VPC | 1 | Red personalizada (10.1.0.0/16) |
| Subnets Privadas | 2 | Aislamiento de cargas de trabajo entre AZs |
| Subnets Públicas | 2 | Recursos orientados a internet |
| Internet Gateway | 1 | Conectividad a internet |
| Virtual Private Gateway | 1 | Punto final VPN de AWS |
| Customer Gateway | 1 | Punto final VPN on-premises |
| Site-to-Site VPN | 1 | Conexión de túnel cifrado |
| Instancia EC2 | 1 | Objetivo de prueba (t2.micro) |
| Security Groups | 1 | Control de acceso de red |

### Comandos de Diagnóstico

```bash
# Logs IPSec
sudo journalctl -u ipsec -f

# Verificación de configuración
sudo ipsec verify

# Depuración de conexión
sudo ipsec whack --debug-all

# Reiniciar servicio
sudo systemctl restart ipsec
```

## Estimación de Costos

| Servicio | Costo Mensual (us-east-1) |
|----------|---------------------------|
| Conexión Site-to-Site VPN | ~$36.00 |
| Virtual Private Gateway | $0.00 |
| EC2 t2.micro | ~$8.50 (Elegible para Free Tier) |
| Transferencia de Datos | Variable |
| **Total** | **~$45/mes** |

## Documentación

- [Guía de Usuario AWS Site-to-Site VPN](https://docs.aws.amazon.com/vpn/latest/s2svpn/)
- [Documentación de Libreswan](https://libreswan.org/wiki/Main_Page)
- [Proveedor AWS de Terraform](https://registry.terraform.io/providers/hashicorp/aws/latest)


## Licencia

Este proyecto está licenciado bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.
