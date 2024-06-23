
# Terraform Remote Backend Configuration with AWS S3 and DynamoDB

## ¿Qué es terraform.tfstate?
El archivo `terraform.tfstate` es un archivo importante generado por Terraform que almacena el estado actual de la infraestructura gestionada. Contiene información sobre los recursos creados, su configuración, relaciones y metadatos relevantes.

## ¿Qué es un backend remoto?
Un backend remoto en Terraform se refiere a la configuración de almacenamiento del estado de Terraform en un servicio de almacenamiento remoto en lugar de almacenarlo localmente en el sistema de archivos. Esto es útil en entornos colaborativos donde varias personas trabajan en la misma infraestructura o en entornos distribuidos donde se necesitan múltiples instancias de Terraform que compartan el mismo estado.

## Servicios remotos
- **AWS S3:** Utilizando un bucket de S3 para almacenar el estado de Terraform.
- **Azure Blob Storage:** Utilizando un contenedor de Blob Storage en Azure.
- **Google Cloud Storage:** Utilizando un bucket de Cloud Storage en Google Cloud Platform.
- **Terraform Cloud/Enterprise:** Utilizando el servicio de backend remoto proporcionado por HashiCorp como parte de Terraform Cloud o Terraform Enterprise.

## Comandos Terraform state
- `terraform show`: Muestra detalles extendidos de la infraestructura.
- `terraform state list`: Muestra una lista rápida de los recursos.
- `terraform state show aws_instance.my_instance`: Muestra información sobre un recurso específico.

## Configuración del backend remoto en S3

Para configurar un backend remoto con AWS S3, necesitas dos recursos antes de aplicar la configuración:
1. **S3 Bucket:** Para almacenar los datos de forma segura y con versionado.
2. **DynamoDB:** Es una base de datos NoSQL administrada por AWS que se usa para el bloqueo de estado.

### Configuración de Terraform

1. **Credenciales de AWS**:
   Configura tus credenciales en `~/.aws/credentials`:
   ```plaintext
   [default]
   aws_access_key_id = TU_ACCESS_KEY_ID
   aws_secret_access_key = TU_SECRET_ACCESS_KEY

2. **Estructura de terrafomr**
   - main-tf
   - variables.tf
   - output.tf
   - provider.tf
   - backend.tf

3.  ** Utilizar los comandos para terrafomr para iniciar**:
```
terraform init
```
```
terrafomr plan
```
```
terrafomr apply
```
