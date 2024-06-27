variable "bucket_name" {
  description = "El nombre del bucket de S3"
  type        = string
}

variable "dynamodb_table_name" {
  description = "El nombre de la tabla de DynamoDB para el bloqueo"
  type        = string
}

variable "region" {
  description = "La región de AWS"
  type        = string
}

variable "state_key" {
  description = "La clave del estado de Terraform en el bucket S3"
  type        = string
}
