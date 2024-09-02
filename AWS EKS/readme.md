Que es EKS?

Es un servicio gestionado de Kubernetes ofrecido por Amazon Web Services (AWS). Permite ejecutar Kubernetes en la nube de AWS sin necesidad de instalar y operar tu propio plano de control de Kubernetes.

Tipos
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

Formas de despliegue

Interfaz Web
Eksclt (cloudformation)
Terrafomr
Cloudformation

Requistos

AWS CLI (Login)
kubeclt

Componentes

VPC
EKS




