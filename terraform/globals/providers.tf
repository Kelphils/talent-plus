provider "aws" {
  region  = "eu-north-1"
  profile = "seerbit"
  default_tags {
    tags = {
      terraform = "ManagedBy-${var.Owner}-${var.project}"
    }
  }
}

# backend configuration for the terraform state in S3 bucket with the DynamoDb table as the backend and encryption, locking enabled
terraform {
  required_version = ">= 1.0.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  # backend "s3" {
  #   # Replace this with your bucket name!
  #   bucket = "alt-school-third-project-terraform-state"
  #   key    = "global/s3/terraform.tfstate"
  #   region = "us-east-1"

  #   # Replace this with your DynamoDB table name!
  #   dynamodb_table = "alt-school-third-project-table"
  #   encrypt        = true
  # }
}
