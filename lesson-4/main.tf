provider "aws" {
  access_key = "AKIAZYSWY6T2DDXUKNTB"
  secret_key = "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"
  region     = "us-east-1"
}

resource "aws_instance" "my_server_web" {
  ami                    = "ami-08c40ec9ead489470"
  instance_type          = "t2.micro"
  key_name               = "ssss"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
 
  tags = {
    Name  = "Server-Web "
    }
    depends_on = [
      aws_instance.my_server_bd, aws_instance.my_server_app
    ]
  } 

  resource "aws_instance" "my_server_app"  {
  ami                    = "ami-08c40ec9ead489470"
  instance_type          = "t2.micro"
  key_name               = "ssss"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
 
  tags = {
    Name  = "Server-Application"
    }

    depends_on = [
      aws_instance.my_server_bd
    ]
  } 

  resource "aws_instance" "my_server_bd" {
  ami                    = "ami-08c40ec9ead489470"
  instance_type          = "t2.micro"
  key_name               = "ssss"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
 
  tags = {
    Name  = "Server-Database"
    }
  } 


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
