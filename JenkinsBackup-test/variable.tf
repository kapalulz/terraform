variable "region" {
  type = string
  description = "Region Name"
  default = "us-east-1"
}

variable "ssh_key_pair" {
  type = string
  description = "SSH key"
  default = "ssss"
}

variable "instance_type" {
  type = string
  description = "Instance Type"
  default = "t2.micro"
}

variable "subnets" {
  type = list
  description = "Subnets"
  default = ["subnet-0400ecbeb8b7732b9"]
}

variable "vpc" {
  type = string
  description = "VPC ID"
  default = "vpc-026acd2829ea53648"
}

variable "env_name" {
  type        = string
  description = "Name of EC2 instance"
  default     = "Bastion"
}