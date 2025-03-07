# Conceptos Fundamentales de Amazon EKS

## ¿Qué es Amazon EKS?
Amazon Elastic Kubernetes Service (EKS) es un servicio gestionado que facilita la ejecución de Kubernetes en AWS sin necesidad de instalar, operar y mantener un plano de control propio. Kubernetes es una plataforma de código abierto para la gestión de aplicaciones en contenedores, y Amazon EKS simplifica su uso al encargarse de las tareas complejas asociadas con la administración de clústeres.

## Componentes Principales de EKS

### Plano de Control (Control Plane)
El plano de control en EKS es responsable de la gestión y coordinación del clúster de Kubernetes e incluye:

- **API Server**: Gestiona las solicitudes entrantes de usuarios y aplicaciones.
- **etcd**: Almacén de datos clave-valor que mantiene el estado del clúster.
- **Scheduler**: Asigna recursos a los pods basándose en requisitos declarados.
- **Controller Manager**: Supervisa y mantiene el estado deseado de los objetos del clúster.

En Amazon EKS, el plano de control está completamente gestionado por AWS y se distribuye entre múltiples zonas de disponibilidad para garantizar alta disponibilidad y tolerancia a fallos.

### Nodos Trabajadores (Worker Nodes)
Los nodos trabajadores son las máquinas virtuales (instancias EC2) que ejecutan las aplicaciones en contenedores y están controlados por el plano de control. Incluyen:

- **kubelet**: Comunica las instrucciones del plano de control al nodo y supervisa los pods.
- **Runtime de contenedores**: Ejecuta los contenedores (Docker, containerd, etc.).
- **kube-proxy**: Gestiona reglas de red y permite la comunicación entre pods y servicios.

## Tipos de Clústeres en Amazon EKS

### 1. Clústeres Gestionados (Managed Clusters)
- AWS gestiona el plano de control.
- Las opciones para nodos trabajadores incluyen:
  - **Nodos Autogestionados**: Instancias EC2 que configuras y administras manualmente.
  - **Nodos Gestionados por EKS**: AWS maneja la creación y gestión del ciclo de vida de los nodos.
  - **Fargate**: Opción sin servidor donde no necesitas gestionar instancias EC2.

### 2. EKS Anywhere
- Permite ejecutar Kubernetes en entornos locales (on-premises) con soporte de AWS.
- Proporciona consistencia entre entornos cloud y locales.

### 3. EKS en AWS Fargate
- Ejecuta pods en un entorno sin servidor.
- No requiere aprovisionar ni gestionar nodos.
- Facturación por pod en lugar de por instancia.

## Ventajas de Amazon EKS

- **Alta disponibilidad**: Plano de control distribuido en múltiples zonas de disponibilidad.
- **Seguridad**: Integración con IAM, encriptación en reposo, y redes VPC seguras.
- **Actualizaciones gestionadas**: AWS facilita las actualizaciones de versiones de Kubernetes.
- **Ecosistema AWS**: Integración con servicios como CloudWatch, ALB, ACM, etc.
- **Comunidad**: Compatibilidad con el ecosistema de herramientas de Kubernetes de código abierto.

## Comparativa de Enfoques

| Característica | Managed EKS | Self-Managed K8s | EKS Anywhere | EKS on Fargate |
|----------------|-------------|------------------|--------------|----------------|
| Gestión del plano de control | AWS | Usuario | AWS (software) | AWS |
| Gestión de nodos | Usuario o AWS | Usuario | Usuario | Sin nodos |
| Ubicación | AWS Cloud | AWS Cloud | On-premises | AWS Cloud |
| Modelo de precios | Por cluster + instancias | Solo instancias | Licencia + hardware | Por pod |
| Escala | Alta | Variable | Media | Alta y sin servidor |
| Casos de uso ideal | Producción en la nube | Control total | Entornos híbridos | Cargas de trabajo variables |

## Mejores Prácticas

1. **Redes**: Utiliza VPC con subredes privadas para los nodos trabajadores.
2. **Seguridad**: Implementa políticas IAM restrictivas y utiliza IRSA (IAM Roles for Service Accounts).
3. **Alta disponibilidad**: Distribuye nodos entre múltiples zonas de disponibilidad.
4. **Monitorización**: Configura CloudWatch y Prometheus para observabilidad.
5. **Actualización**: Mantén actualizado el cluster con versiones recientes de Kubernetes.

## Recursos Adicionales
- [Documentación Oficial de Amazon EKS](https://docs.aws.amazon.com/eks/)
- [Guía de Mejores Prácticas de EKS](https://aws.github.io/aws-eks-best-practices/)
- [Repositorio de Ejemplos de EKS](https://github.com/aws-samples/amazon-eks-ami)
