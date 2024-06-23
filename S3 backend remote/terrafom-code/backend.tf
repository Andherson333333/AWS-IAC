terraform {
  backend "s3" {
    bucket         = var.bucket_name
    key            = var.state_key
    region         = var.region
    encrypt        = true
    dynamodb_table = var.dynamodb_table_name
  }
}
