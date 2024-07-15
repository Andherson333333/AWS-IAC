# AWS Resource Inventory Lambda

## Descripción
Este proyecto utiliza Terraform para desplegar una función AWS Lambda que realiza un inventario periódico de recursos en tu cuenta de AWS. La función se ejecuta automáticamente según un horario configurable, recopilando información sobre varios servicios de AWS como EC2, S3, RDS, y más.

## Características
- Inventario automatizado de recursos AWS
- Despliegue completo utilizando Terraform
- Función Lambda con permisos de solo lectura
- Programación flexible mediante CloudWatch Events
- Soporte para múltiples servicios de AWS (EC2, S3, Lambda, RDS, DynamoDB, ECS, EKS, ElastiCache, Redshift, SQS)

## Prerequisitos
- [Terraform](https://www.terraform.io/downloads.html) (v0.12+)
- [AWS CLI](https://aws.amazon.com/cli/) configurado con las credenciales apropiadas
- Python 3.12 (para desarrollo local y pruebas)

## Estructura del Proyecto
```
.
├── main.tf              # Configuración principal de Terraform
├── variables.tf         # Definición de variables de Terraform
├── terraform.tfvars     # Valores de las variables
└── README.md            # Este archivo
```

## Configuración y Despliegue

1. Modifica `terraform.tfvars` si necesitas personalizar alguna variable.

2. Inicializa Terraform:
   ```
   terraform init
   ```

3. Revisa los cambios planificados:
   ```
   terraform plan
   ```

4. Aplica la configuración:
   ```
   terraform apply
   ```

5. Confirma la creación de los recursos escribiendo `yes` cuando se te solicite.

## Uso
Una vez desplegado, la función Lambda se ejecutará automáticamente según la programación configurada. Para verificar su funcionamiento:

1. Accede a la consola de AWS y navega a CloudWatch > Log groups.
2. Busca el grupo de logs `/aws/lambda/resource_inventory_lambda`.
3. Revisa los streams de logs para ver los resultados de las ejecuciones.

Para una ejecución manual, puedes usar el siguiente comando AWS CLI:
```
aws lambda invoke --function-name resource_inventory_lambda output.json
```

## Personalización
- Modifica el archivo `terraform.tfvars` para ajustar las variables según tus necesidades.
- Para cambiar la programación de ejecución, actualiza la variable `schedule_expression` en `terraform.tfvars`. Por ejemplo:
  ```hcl
  schedule_expression = "cron(0 12 * * ? *)"  # Ejecutar diariamente a las 12 PM UTC
  ```
- Formato de la expresión cron:
  - Los campos son: minuto hora día-del-mes mes día-de-la-semana año
  - Usa `cron(0 1 * * ? *)` para ejecutar diariamente a la 1 AM UTC
  - Usa `rate(1 day)` para ejecutar cada 24 horas
  - Para más información, consulta la [documentación de AWS sobre expresiones de programación](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html)

## Variables de Terraform

| Nombre | Descripción | Tipo | Valor por defecto |
|--------|-------------|------|-------------------|
| `lambda_role_name` | Nombre del rol IAM para Lambda | string | - |
| `lambda_filename` | Nombre del archivo de despliegue de Lambda | string | - |
| `lambda_function_name` | Nombre de la función Lambda | string | - |
| `lambda_handler` | Manejador de la función Lambda | string | - |
| `lambda_runtime` | Runtime de la función Lambda | string | - |
| `lambda_environment_variables` | Variables de entorno para Lambda | map(string) | {} |
| `lambda_code` | Código de la función Lambda | string | - |
| `schedule_expression` | Expresión de programación para CloudWatch Events | string | `"cron(0 1 * * ? *)"` |

## Limpieza
Para eliminar todos los recursos creados:
```
terraform destroy
```

![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWS%20lambda%20mostrar%20servicios/imagenes/lambda-1.png)

![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWS%20lambda%20mostrar%20servicios/imagenes/lambda-2.png)

![Terraform 1](https://github.com/Andherson333333/AWS-IAC/blob/main/AWS%20lambda%20mostrar%20servicios/imagenes/lambda-3.png)


