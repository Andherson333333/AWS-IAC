# AWS Resource Inventory Lambda

## Descripción
Este proyecto utiliza Terraform para desplegar una función AWS Lambda que realiza un inventario diario de recursos en tu cuenta de AWS. La función se ejecuta automáticamente cada día a la 1 AM UTC, recopilando información sobre varios servicios de AWS como EC2, S3, RDS, y más.

## Características
- Inventario automatizado diario de recursos AWS
- Despliegue completo utilizando Terraform
- Función Lambda con permisos de solo lectura
- Programación automática mediante CloudWatch Events
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
├── outputs.tf           # Outputs de Terraform (opcional)
└── README.md            # Este archivo
```

## Configuración y Despliegue
1. Clona este repositorio:
   ```
   git clone https://github.com/tu-usuario/aws-resource-inventory-lambda.git
   cd aws-resource-inventory-lambda
   ```

2. Modifica `terraform.tfvars` si necesitas personalizar alguna variable.

3. Inicializa Terraform:
   ```
   terraform init
   ```

4. Revisa los cambios planificados:
   ```
   terraform plan
   ```

5. Aplica la configuración:
   ```
   terraform apply
   ```

6. Confirma la creación de los recursos escribiendo `yes` cuando se te solicite.

## Uso
Una vez desplegado, la función Lambda se ejecutará automáticamente cada día a la 1 AM UTC. Para verificar su funcionamiento:

1. Accede a la consola de AWS y navega a CloudWatch > Log groups.
2. Busca el grupo de logs `/aws/lambda/resource_inventory_lambda`.
3. Revisa los streams de logs para ver los resultados de las ejecuciones.

Para una ejecución manual, puedes usar el siguiente comando AWS CLI:
```
aws lambda invoke --function-name resource_inventory_lambda output.json
```

## Personalización
- Modifica el archivo `terraform.tfvars` para ajustar las variables según tus necesidades.
- Para cambiar la programación de ejecución, actualiza la expresión cron en el recurso `aws_cloudwatch_event_rule` en `main.tf`.

## Limpieza
Para eliminar todos los recursos creados:
```
terraform destroy
```

## Contribuir
Las contribuciones son bienvenidas. Por favor, abre un issue para discutir cambios mayores antes de enviar un pull request.

## Licencia
[MIT](https://choosealicense.com/licenses/mit/)

## Contacto
Tu Nombre - [tu-email@ejemplo.com](mailto:tu-email@ejemplo.com)

Enlace del Proyecto: [https://github.com/tu-usuario/aws-resource-inventory-lambda](https://github.com/tu-usuario/aws-resource-inventory-lambda)
