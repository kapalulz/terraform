provider "aws" {
  region     = "us-east-1"
  access_key = "*******************"
  secret_key = "*******************"
}

terraform {
  backend "s3" {
    bucket = "terraform-s3-kapalulz"
    key    = "globalvars/terraform.tfstate"
    region = "us-east-1"
  }
}



output "company_name" {
  value = ""
}

output "owner" {
  value = "Kashuba Oleksandr"
}

output "tags" {
  value = {
    Project    = "CubeGoToFly"
    CostCenter = "R&D"
    Country    = "USA"
  }
}


