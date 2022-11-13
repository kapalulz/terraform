provider "aws" {
    access_key = "AKIAZYSWY6T2DDXUKNTB"
    secret_key = "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"
    region =  "us-east-1"
  }

  resource "aws_default_vpc" "default" {} # This need to be added since AWS Provider v4.29+ to get VPC id

  resource "aws_instance" "my_webserver" {
    ami                    = "ami-08c40ec9ead489470"
    instance_type          = "t2.micro"
    key_name               = "ssss"
    vpc_security_group_ids = [aws_security_group.my_webserver.id]
    user_data              = <<EOF
#!/bin/bash
echo "*** Installing apache2"
sudo apt update -y
sudo apt install apache2 -y
echo "<h2>WebServer with IP: $myip </h2><br>Pupa Zalupa1!"  >  /var/www/html/index.html
echo "<br><h2>Loriska Sosiska</h2> > /var/www/html/index.html
echo "<br><h2>$ip $myip</h2> > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
echo "*** Completed Installing Apache2"
echo "WooOOoOOoOooOooOOOooooooooooooooooooOooOooooooOooooooooooooOooOOOOOooOoW"
EOF

    tags = {
      Name  = "Web Server Build by Terraform"
      Owner = "Oleksandr Kashuba"
    }
  }
 
 resource "aws_security_group" "my_webserver" {
    name        = "WebServer Security Group"
    description = "My First SecurityGroup"
    vpc_id      = aws_default_vpc.default.id # This need to be added since AWS Provider v4.29+ to set VPC id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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


