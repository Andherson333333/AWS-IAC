variable "bucket_name" {
  description = "El nombre del bucket de S3"
  type        = string
  default     = "andherson-s3-demo-xyz"
}

variable "tags" {
  description = "Etiquetas para el bucket de S3"
  type        = map(string)
  default     = {
    Environment = "Dev"
    Project     = "S3Demo"
  }
}
