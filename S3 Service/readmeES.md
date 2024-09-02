# Proyecto Amazon S3 (Simple Storage Service)

Este proyecto demuestra la configuración y gestión de buckets de Amazon S3 utilizando Terraform y CloudFormation, siguiendo las mejores prácticas de AWS.

## Tabla de Contenidos
- [¿Qué es Amazon S3?](#qué-es-amazon-s3)
- [Características Clave](#características-clave)
- [Casos de Uso Comunes](#casos-de-uso-comunes)
- [Cómo Funciona](#cómo-funciona)
- [Creación de un Bucket S3 con Terraform](#creación-de-un-bucket-s3-con-terraform)
- [Creación de un Bucket S3 con CloudFormation](#creación-de-un-bucket-s3-con-cloudformation)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Comenzando](#comenzando)

[... contenido anterior sin cambios ...]

## Creación de un Bucket S3 con CloudFormation

Este proyecto también incluye una plantilla de CloudFormation para crear un bucket S3 con las mejores prácticas. La plantilla se encuentra en el archivo `cloudformation-template.yaml`.

### Características de la Plantilla:

- **Versionado habilitado**: Mantiene múltiples versiones de los objetos.
- **Reglas de ciclo de vida configuradas**: Gestiona automáticamente la transición y expiración de objetos.
- **Cifrado habilitado por defecto**: Asegura que todos los objetos se almacenen cifrados.

### Parámetros Configurables:

- `BucketName`: El nombre del bucket de S3 (por defecto: "andherson-s3-demo-xyz")
- `Environment`: El entorno para el que se crea el bucket (por defecto: "Dev")
- `Project`: El proyecto asociado con el bucket (por defecto: "S3Demo")

### Componentes Clave:

- **Lifecycle Configuration**: 
  - Transiciona objetos a la clase de almacenamiento GLACIER después de 30 días.
  - Expira objetos después de 365 días.
  - Expira versiones no actuales después de 90 días.
- **Bucket Encryption**: Habilita el cifrado del lado del servidor con AES256.
- **Versioning**: Habilita el versionado del bucket.
- **Tags**: Añade etiquetas para Environment y Project.

### Outputs:

- `BucketId`: Proporciona el nombre del bucket S3 creado.

## Estructura del Proyecto

```
.
├── terraform-code/
│   ├── main.tf
│   └── variables.tf
├── cloudformation-template.yaml
└── README.md
```

## Comenzando

### Con Terraform:

1. Clona este repositorio.
2. Navega al directorio `terraform-code`.
3. Actualiza el archivo `variables.tf` con el nombre del bucket y las etiquetas deseadas.
4. Ejecuta los siguientes comandos:

   ```
   terraform init
   terraform plan
   terraform apply
   ```

### Con CloudFormation:

1. Accede a la consola de AWS CloudFormation.
2. Crea una nueva pila y sube el archivo `cloudforamtion-code/stack.yml`.
3. Configura los parámetros según tus necesidades.
4. Revisa y crea la pila.

5. Confirma la creación verificando en la consola de AWS S3.

---

Para más información sobre los precios de Amazon S3 y configuraciones avanzadas, por favor consulta la [documentación oficial de AWS](https://aws.amazon.com/s3/).
