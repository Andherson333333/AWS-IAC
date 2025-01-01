# Amazon EKS (Elastic Kubernetes Service)

Este repositorio tiene el propósito de explicar qué es EKS y también desplegarlo con Terraform, con dos configuraciones posibles:

- **Terraform1**: Usando módulos.
- **Terraform2**: Sin módulos.

## Requisitos

- AWS CLI
- Terraform

## Despliegue

1. **Inicializar Terraform**:
   ```
   terraform init
   ```

2. **Planificar la infraestructura**:
   ```
   terraform plan
   ```

3. **Destruir la infraestructura**:
   ```
   terraform destroy
   ```

## ¿Qué es Amazon EKS?
Amazon Elastic Kubernetes Service (EKS) es un servicio administrado que facilita la ejecución de Kubernetes en AWS sin la necesidad de instalar, operar y mantener un plano de control de Kubernetes. Kubernetes es una plataforma de código abierto para la gestión de aplicaciones en contenedores, y Amazon EKS simplifica su uso al encargarse de las tareas complejas asociadas con la administración de clústeres.

## ¿Qué es el Control Plane?
El plano de control (control plane) en EKS es responsable de la gestión y coordinación del clúster de Kubernetes. Incluye componentes como:
- **API Server**: Gestiona las solicitudes entrantes de los usuarios y aplicaciones.
- **Etcd**: Almacén de datos clave-valor que guarda el estado de todo el clúster.
- **Scheduler**: Asigna recursos a los pods basándose en las necesidades declaradas.
- **Controller Manager**: Supervisa y mantiene el estado deseado de los objetos del clúster.

En Amazon EKS, el plano de control está completamente administrado por AWS y se distribuye en varias zonas de disponibilidad para garantizar alta disponibilidad y tolerancia a fallos.

## ¿Qué son los Worker Nodes?
Los nodos de trabajo (worker nodes) son las máquinas virtuales (EC2 instances) que ejecutan las aplicaciones en contenedores y están controladas por el plano de control. Los nodos de trabajo contienen:
- **kubelet**: Comunica las instrucciones del plano de control al nodo y supervisa los pods.
- **Runtime de contenedores**: Ejecuta los contenedores (Docker, containerd, etc.).
- **Kube-proxy**: Gestiona las reglas de red y permite la comunicación entre pods y servicios.

## Tipos de Clústeres en Amazon EKS
1. **Clústeres Administrados**:
   - AWS gestiona el plano de control.
   - Los usuarios son responsables de los nodos de trabajo (self-managed nodes) o pueden usar nodos administrados por EKS (EKS Managed Nodes).

2. **EKS Anywhere**:
   - Permite ejecutar Kubernetes on-premises con soporte de AWS.

3. **EKS en AWS Fargate**:
   - Ejecuta pods en un entorno serverless sin necesidad de gestionar nodos.

## Diferencias Clave
| Característica             | Administrado por AWS            | Nodos Auto-gestionados           |
|-----------------------------|----------------------------------|-----------------------------------|
| **Plano de Control**        | Totalmente administrado         | Administrado por AWS             |
| **Nodos de Trabajo**        | EKS Managed Nodes o Fargate     | EC2 instances administradas por el usuario |
| **Escalabilidad Automática**| Soportada en Fargate y EKS Autoscaler | Requiere configuración manual   |
| **Operaciones On-premises** | EKS Anywhere                    | No disponible                    |

## Ventajas de Amazon EKS
- **Alta disponibilidad**: El plano de control está distribuido en múltiples zonas de disponibilidad.
- **Integración con servicios de AWS**: Integrado con IAM, CloudWatch, ALB, entre otros.
- **Flexibilidad**: Soporte para múltiples opciones de ejecución de nodos y entornos.
- **Seguridad**: Encripción en reposo y tráfico seguro por defecto.

## Recursos Adicionales
- [Documentación Oficial de Amazon EKS](https://docs.aws.amazon.com/eks/)
- [Introducción a Kubernetes](https://kubernetes.io/docs/concepts/)
- [Tutoriales de AWS para EKS](https://aws.amazon.com/getting-started/hands-on/)




