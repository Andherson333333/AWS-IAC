## ¿Que es EKS?

Es un servicio gestionado de Kubernetes ofrecido por Amazon Web Services (AWS). Permite ejecutar Kubernetes en la nube de AWS sin necesidad de instalar y operar tu propio plano de control de Kubernetes.

## Tipos de nodos en EKS

| Característica | Nodos EC2 | Fargate | Nodos Gestionados | Nodos Spot |
|----------------|-----------|---------|-------------------|------------|
| Gestión de infraestructura | Manual | Automática | Semi-automática | Manual |
| Flexibilidad | Alta | Baja | Media | Alta |
| Costo | Variable | Pago por uso | Variable | Bajo |
| Escalabilidad | Manual/Auto Scaling | Automática | Auto Scaling | Manual/Auto Scaling |
| Mantenimiento del SO | Usuario | AWS | AWS | Usuario |
| Personalización | Alta | Limitada | Media | Alta |
| Ideal para | Cargas de trabajo específicas | Aplicaciones stateless | Equilibrio control/facilidad | Cargas tolerantes a interrupciones |
| Tiempo de aprovisionamiento | Minutos | Segundos | Minutos | Minutos |
| Persistencia de datos | Soportada | Limitada | Soportada | No recomendada |
| Integración con servicios AWS | Completa | Buena | Completa | Completa |
| Complejidad de configuración | Alta | Baja | Media | Alta |

## Formas de despliegue
- Consola de AWS (Interfaz Web)
- eksctl (herramienta de línea de comandos que utiliza CloudFormation)
- Terraform
- AWS CloudFormation

## Requisitos
- Cuenta de AWS
- AWS CLI configurado
- kubectl instalado y configurado
- Roles y políticas IAM apropiados
- VPC configurada con subredes públicas y privadas

## Componentes principales
- Plano de control gestionado de Kubernetes
- Nodos de trabajo (EC2, Fargate, etc.)
- VPC y configuración de red

## Despligues Terraform

Hay configuraciones terrafomr :

1 - Terraform-code1 : Esta configurada con modulos hecho por la comunidad vpc,eks .
2 - Terraform-code2 : Esta configurado sin modulo a diferencia de eks un solo .tf en el eks esta separado por node.tf y eks.tf que es el control plane lo demas es lo mismo
