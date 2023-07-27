provider "aws" {
  region = "eu-north-1"
  # profile = "default"
  default_tags {
    tags = {
      terraform = "ManagedBy ${var.Owner} ${var.project}"
    }
  }
}

# backend configuration for the terraform state in S3 bucket with the DynamoDb table as the backend and encryption, locking enabled
terraform {
  required_version = ">= 1.0.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.17"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.8"
    }
  }
  backend "s3" {
    # Replace this with your bucket name!
    key    = "tplus/infra/terraform.tfstate"
    bucket = "tplus-project-terraform-state-bucket"
    # profile = "default"

  }
}
