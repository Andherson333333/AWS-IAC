## Configuración

### Variables Locales

- `name`: Prefijo de nombre para los recursos (por defecto: "my-eks")
- `region`: Región de AWS (por defecto: "us-east-1")
- `vpc_cidr`: Bloque CIDR de la VPC (por defecto: "10.0.0.0/16")
- `azs`: Lista de Zonas de Disponibilidad (por defecto: las primeras 2 AZs en la región)

### VPC

- Utiliza el módulo `terraform-aws-modules/vpc/aws` (versión 5.13.0)
- Crea subredes públicas, privadas e internas
- Habilita NAT Gateway y soporte DNS

### Cluster EKS

- Utiliza el módulo `terraform-aws-modules/eks/aws` (versión 20.23.0)
- Despliega EKS versión 1.30
- Habilita IRSA (IAM Roles for Service Accounts)
- Incluye los addons CoreDNS, kube-proxy y vpc-cni
- Despliega un grupo de nodos gestionados con instancias t3.medium

## Personalización

Puedes personalizar el despliegue modificando las variables locales y las configuraciones de los módulos en los archivos de Terraform.

