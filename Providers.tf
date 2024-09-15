terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.49.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = "Replace_Me"
  secret_key = "Replace_Me"
}



