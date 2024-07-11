# Proyecto Amazon S3 (Simple Storage Service)

Este proyecto demuestra la configuración y gestión de buckets de Amazon S3 utilizando Terraform, siguiendo las mejores prácticas de AWS.

## Tabla de Contenidos
- [¿Qué es Amazon S3?](#qué-es-amazon-s3)
- [Características Clave](#características-clave)
- [Casos de Uso Comunes](#casos-de-uso-comunes)
- [Cómo Funciona](#cómo-funciona)
- [Creación de un Bucket S3 con Terraform](#creación-de-un-bucket-s3-con-terraform)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Comenzando](#comenzando)

## ¿Qué es Amazon S3?

Amazon S3 es un servicio de almacenamiento de objetos en la nube que ofrece escalabilidad, disponibilidad de datos, seguridad y rendimiento líderes en la industria. Los usuarios pueden almacenar y recuperar cualquier cantidad de datos en cualquier momento y desde cualquier lugar en la web.

## Características Clave

- **Almacenamiento de Objetos**: S3 almacena datos como objetos dentro de buckets.
- **Escalabilidad**: Altamente escalable, capaz de manejar grandes cantidades de datos y un número elevado de solicitudes.
- **Durabilidad y Disponibilidad**: Diseñado para una durabilidad de 99,999999999% y una disponibilidad de 99,99%.
- **Seguridad**: Proporciona cifrado en tránsito (SSL/TLS) y en reposo, además de permisos de acceso mediante políticas de bucket y listas de control de acceso (ACL).
- **Control de Versiones**: Mantiene múltiples versiones de un mismo objeto.
- **Replicación**: Soporta la replicación de objetos en diferentes regiones (Cross-Region Replication, CRR).
- **Integración con servicios de AWS**: Se integra perfectamente con otros servicios de AWS.

## Casos de Uso Comunes

- Almacenamiento y Distribución de Contenidos
- Backup y Recuperación
- Archivado
- Big Data y Análisis
- Almacenamiento de Archivos de Aplicaciones

## Cómo Funciona

### Creación de un Bucket
1. Accede a la consola de Amazon S3.
2. Haz clic en "Create bucket".
3. Introduce un nombre único para el bucket y selecciona la región.
4. Configura las opciones de seguridad y permisos.
5. Completa la creación del bucket.

### Subida de Objetos
1. Selecciona el bucket donde quieres subir el objeto.
2. Haz clic en "Upload".
3. Selecciona los archivos desde tu computadora.
4. Configura las opciones de almacenamiento y permisos.
5. Inicia la subida.

### Gestión de Objetos
- Habilita el versionado para mantener versiones múltiples de un objeto.
- Configura la replicación para copiar objetos a otros buckets en diferentes regiones.
- Administra el acceso a los objetos mediante políticas de bucket y listas de control de acceso.

## Creación de un Bucket S3 con Terraform

Este proyecto incluye código Terraform para crear un bucket S3 con las mejores prácticas, incluyendo versionado, políticas de ciclo de vida y cifrado por defecto. El código se encuentra en la carpeta `terraform-code`.

### Componentes Clave:

- `aws_s3_bucket`: Crea un bucket S3 con el nombre y las etiquetas especificadas, habilitando el cifrado por defecto con AES256.
- `aws_s3_bucket_lifecycle_configuration`: Configura las reglas de ciclo de vida del bucket:
  - Transiciona los objetos a la clase de almacenamiento GLACIER después de 30 días.
  - Expira los objetos después de 365 días.
  - Expira las versiones no actuales después de 90 días.
- `aws_s3_bucket_versioning`: Habilita el versionado del bucket.

![Diagrama S3](https://github.com/Andherson333333/AWS-IAC/blob/main/S3%20Service/imagenes/s3-1.png)

## Estructura del Proyecto

```
.
├── terraform-code/
│   ├── main.tf
│   └── variables.tf
└── README.md
```

## Comenzando

1. Clona este repositorio.
2. Navega al directorio `terraform-code`.
3. Actualiza el archivo `variables.tf` con el nombre del bucket y las etiquetas deseadas.
4. Ejecuta los siguientes comandos:

   ```
   terraform init
   terraform plan
   terraform apply
   ```

5. Confirma la creación verificando en la consola de AWS S3.

---

Para más información sobre los precios de Amazon S3 y configuraciones avanzadas, por favor consulta la [documentación oficial de AWS](https://aws.amazon.com/s3/).
