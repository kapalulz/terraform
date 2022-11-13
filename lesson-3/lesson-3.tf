provider "aws" {
  access_key = "***************"
  secret_key = "***************"
  region     = "us-east-1"
}

resource "aws_default_vpc" "default" {} # This need to be added since AWS Provider v4.29+ to get VPC id

  resource "aws_eip" "my_static_ip"{
    instance = aws_instance.my_webserver.id #Creating static IP - $$$ - ?
  }

resource "aws_instance" "my_webserver" {
  ami                    = "ami-08c40ec9ead489470"
  instance_type          = "t2.micro"
  key_name               = "ssss"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data              = templatefile("user-data.sh.tpl", {
    f_name = "Alex",
    l_name = "Kashuba",
    names = ["Vasya", "Kolya", "Petya", "John", "Donald", "Masha", "Katya"]
  }) 
  
  tags = {
    Name  = "Web Server Build by Terraform"
    Owner = "Oleksandr Kashuba"
  }


  lifecycle {
  create_before_destroy = true #Create new server before destroy
}

}

resource "aws_security_group" "my_webserver" {
  name        = "Dynamic Security Group"

  dynamic "ingress" {
    for_each = ["80","443","8080","1541", "9092", "22"]
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
