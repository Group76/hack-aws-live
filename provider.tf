terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  cloud {
    organization = "group76"

    workspaces {
      name = "aws-hackaton-infrastructure"
    }
  }
}

provider "aws" {
  region = var.region
}