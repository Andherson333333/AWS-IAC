terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.2.0"
}

# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"  # Región de AWS en la que deseas operar
  access_key = "VI" 
  secret_key = "R"  
}
