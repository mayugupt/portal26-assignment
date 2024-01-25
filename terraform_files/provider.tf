# Terraform details
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Provider details
provider "aws" {
  region = "us-east-1"
  access_key = "AKIA6HU6OMTUYLHOCFP2"
  secret_key = "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"
}

