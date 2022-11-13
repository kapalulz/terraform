data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "kapalulz-project-terraform-state"          // Bucket from where to GET Terraform State
    key    = "dev/network/terraform.tfstate"             // Object name in the bucket to GET Terraform state
    region = "us-east-1"                                 // Region where bycket created
  }
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


output "network_details" {
  value = data.aws_ami.latest_amazon_linux
}

