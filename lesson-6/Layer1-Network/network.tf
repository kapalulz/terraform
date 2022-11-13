provider "aws" {
  access_key = "***************"
  secret_key = "***************"
  region     = "us-east-1"
}

//Save tf.state in S3 Bucket
terraform {
  backend "s3" {
    bucket = "kapalulz-project-terraform-state"
    key = "dev/network/terraform.tfstate"
    region = "us-east-1"
  }
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "My PC"
  }
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
  }


output "vpc_id" {
    value = aws_vpc.main.id
}

output "vpc_cidr_block" {
    value = aws_vpc.main.cidr_block
}
  
