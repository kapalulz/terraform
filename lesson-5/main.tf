#----------------------------------------------------------
# Provision Highly Availabe Web in any Region Default VPC
# Create:
#    - Security Group for Web Server
#    - Launch Configuration with Auto AMI Lookup
#    - Auto Scaling Group using 2 Availability Zones
#    - Classic Load Balancer in 2 Availability Zones
#
# Made by Oleksandr Kashuba November-4-2022
#-----------------------------------------------------------

provider "aws" {
  access_key = "AKIAZYSWY6T2DDXUKNTB"
  secret_key = "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"
  region     = "us-east-1"
}

data "aws_availability_zones" "available" {

}

data "aws_ami" "latest_ubuntu" {
  owners = ["099720109477"]
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
} 

#-----------------------------------------------------------
resource "aws_instance" "my_server_web" {
  ami                    = "ami-08c40ec9ead489470"
  instance_type          = "t2.micro"
  key_name               = "ssss"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
}

#--------------------Security Group------------------------
resource "aws_security_group" "my_webserver" {
  name        = "Dynamic Security Group"

  dynamic "ingress" {
    for_each = ["80","443","22"]
  content {
    from_port   = ingress.value
    to_port     = ingress.value
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Web Server SecurityGroup"
    Owner = "Kap-Security"
  }
}

#------------------Launch Configuration-----------------------
resource "aws_launch_configuration" "web" {
  #name          = "WebServer-Highly-Available-LC"
  name_prefix   = "WebServer-Highly-Available-LC-"
  image_id      = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.my_webserver.id]
  user_data = file("user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}

#------------------Auto Scaling Group-----------------------
resource "aws_autoscaling_group" "name" {
name = "ASG-${aws_launch_configuration.web.name}"
launch_configuration = aws_launch_configuration.web.name
min_size = 2
max_size = 2
min_elb_capacity = 2
health_check_type = "ELB"
vpc_zone_identifier = [aws_default_subnet.default_az1.id,aws_default_subnet.default_az2.id]
load_balancers  = [aws_elb.web.name]

  dynamic "tag" {
    for_each = {
      Name = "WebServer in ASG"
      Owner = "Oleksandr Kashuba"
      TAGKEY = "TAGVALUE"
    }
  content {
    key = tag.key
    value = tag.value
    propagate_at_launch = true    
  }
}

 lifecycle {
    create_before_destroy = true
  }
}


resource "aws_elb" "web" {
  name = "WebServer-HA-ELB"
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
    security_groups = [aws_security_group.my_webserver.id]
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = 80
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 10
  }
  tags = {
    Name = "ebServer-Highly-Available-ELB"
  }
}


resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}

#----------------------------------------------------------------------------
output "web_loadbalancer_url"{
  value = aws_elb.web.dns_name
}

output "latest_ubuntu_ami_id"{
  value = data.aws_ami.latest_ubuntu.id
}

output "latest_ubuntu_ami_name"{
  value = data.aws_ami.latest_ubuntu.name
}