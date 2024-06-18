# Amazon S3 (Simple Storage Service)

## ¿Qué es Amazon S3?

Amazon S3 es un servicio de almacenamiento de objetos en la nube que proporciona escalabilidad, disponibilidad de datos, seguridad y rendimiento líderes en la industria. Los usuarios pueden almacenar y recuperar cualquier cantidad de datos en cualquier momento y desde cualquier lugar en la web.

## Características Clave

- **Almacenamiento de Objetos**: S3 almacena datos como objetos dentro de buckets. Un objeto es un archivo y cualquier metadato asociado con él. Los buckets son contenedores para almacenar objetos.
- **Escalabilidad**: Altamente escalable, capaz de manejar grandes cantidades de datos y un número elevado de solicitudes.
- **Durabilidad y Disponibilidad**: Diseñado para una durabilidad de 99.999999999% (11 nueves) y una disponibilidad de 99.99%.
- **Seguridad**: Proporciona cifrado en tránsito (SSL/TLS) y en reposo, además de permisos de acceso mediante políticas de bucket y listas de control de acceso (ACL).
- **Control de Versiones**: Mantiene múltiples versiones de un mismo objeto, útil para protegerse contra la pérdida de datos y eliminaciones accidentales.
- **Replicación**: Soporta la replicación de objetos en diferentes regiones (Cross-Region Replication, CRR).
- **Integración con otros servicios de AWS**: Se integra perfectamente con servicios como Amazon CloudFront, AWS Lambda, Amazon RDS, entre otros.

## Casos de Uso Comunes

- **Almacenamiento y Distribución de Contenidos**: Ideal para almacenar y distribuir contenido estático como imágenes, videos y documentos.
- **Backup y Recuperación**: Utilizado para el almacenamiento de copias de seguridad y recuperación de datos.
- **Archivado**: Usado junto con Amazon Glacier para archivado a largo plazo.
- **Big Data y Análisis**: Funciona como un almacén de datos para soluciones de big data.
- **Almacenamiento de Archivos de Aplicaciones**: Almacena archivos de aplicaciones como logs y datos de configuración.

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

- **Versionado**: Habilita el versionado para mantener versiones múltiples de un objeto.
- **Replicación**: Configura la replicación para copiar objetos a otros buckets en diferentes regiones.
- **Políticas y ACLs**: Administra el acceso a los objetos mediante políticas de bucket y listas de control de acceso.

## Precios

La estructura de precios de Amazon S3 incluye:

- **Almacenamiento**: Pago por GB almacenado por mes.
- **Solicitudes y Recuperación de Datos**: Pago por número de solicitudes y cantidad de datos transferidos.
- **Transferencia de Datos**: Costos asociados por transferencias de datos hacia fuera de S3 (excepto hacia otros servicios de AWS).



Amazon S3 es una solución robusta y versátil para el almacenamiento de objetos en la nube, adecuada para una amplia gama de necesidades de almacenamiento.

## Creacion S3 con IAC

Se procederá a crear un bucket S3 con las prácticas recomendadas que incluyen versionado, ciclo de vida y cifrado habilitado por defecto. El código se encuentra en la carpeta terraform-code.

### Explicación
- aws_s3_bucket: Este recurso crea un bucket S3 con el nombre y las etiquetas especificadas. Además, habilita el cifrado por defecto utilizando el algoritmo AES256.
- aws_s3_bucket_lifecycle_configuration: Este recurso configura las reglas de ciclo de vida del bucket. La regla de ejemplo: 
- Transiciona los objetos a la clase de almacenamiento GLACIER después de 30 días.
- Expira los objetos después de 365 días.
- Expira las versiones no actuales después de 90 días.
- aws_s3_bucket_versioning: Este recurso habilita el versionado del bucket.
- Esta configuración sigue las mejores prácticas de AWS al habilitar el versionado, configurar políticas de ciclo de vida y habilitar el cifrado por defecto, asegurando así que los datos almacenados sean seguros y administrados de manera eficiente




