terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.48.0" #aws provider version not terrafomr
    }
  }

  backend "s3" {
    bucket = "guru-remote-state"
    key    = "provisioner"
    region = "us-east-1"
    dynamo_table = "guru-locking"
  }
}

provider "aws" {
  region = "us-east-1"
}