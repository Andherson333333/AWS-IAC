################################################################
# S3 Bucket Module - Configuración independiente
################################################################
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

################################################################
# Módulo S3 Bucket
################################################################
module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.2.1"

  bucket = "my-vpc-endpoint-bucket-${random_string.bucket_suffix.result}"

  # Configuración de acceso
  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true


  versioning = {
    enabled = true
  }

  tags = local.tags
}
