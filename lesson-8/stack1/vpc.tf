provider "aws" {
  region     = "us-east-1"
  access_key = "*******************"
  secret_key = "*******************"
}

data "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    bucket = "terraform-s3-kapalulz"
    key    = "globalvars/terraform.tfstate"
    region = "us-east-1"
    access_key = "AKIAZYSWY6T2AQLJDHFC"
    secret_key = "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"
  }
}

#data.terraform_remote_state.global.outputs.company_name

locals {
  company_name = data.terraform_remote_state.global.outputs.company_name
  owner_name   = data.terraform_remote_state.global.outputs.owner
  common_tags  = data.terraform_remote_state.global.outputs.tags
}


#---------------------------------------------------------------------------

resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name    = "Stack1-VPC1"
    Company = data.terraform_remote_state.global.outputs.company_name
    Owner   = data.terraform_remote_state.global.outputs.owner
  }
}


resource "aws_vpc" "vpc2" {
  cidr_block = "10.0.0.0/16"
  tags       = merge(data.terraform_remote_state.global.outputs.tags, { Name = "Stack1-VPC2" })
}
