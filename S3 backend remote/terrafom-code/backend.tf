terraform {
  backend "s3" {
    bucket         = "andherson-s3-demo-xyz" # Cambia esto al nombre de tu bucket S3
    key            = "andherson/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
