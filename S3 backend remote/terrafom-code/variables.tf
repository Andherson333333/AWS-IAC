variable "bucket_name" {
  description = "El nombre del bucket de S3"
  type        = string
  default     = "andherson-s3-demo-xyz"
}

variable "dynamodb_table_name" {
  description = "El nombre de la tabla de DynamoDB para el bloqueo"
  type        = string
  default     = "terraform-lock"
}

variable "region" {
  description = "La región de AWS"
  type        = string
  default     = "us-east-1"
}

variable "state_key" {
  description = "La clave del estado de Terraform en el bucket S3"
  type        = string
  default     = "andherson/terraform.tfstate"
}
