provider "aws" {
    region         =   "us-east-1"
} 

resource "aws_instance" "website" {
  ami = "ami-08fdec01f5df9998f"
  instance_type    = "t2.micro"
  key_name         = "KeyForEc2"
  vpc_security_group_ids  = [aws_security_group.bastion-server.id]
  user_data = file("user_data.sh")

  tags={
  Name          = "WebServer"
  }
}


resource "aws_security_group" "bastion-server" {
  name          = "SSH security group"
  vpc_id        = var.vpc
  description   = "Security Group for Bastion server"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    
    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

      ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

      ingress {
    from_port   = 8080
    to_port     = 8080
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
    Name        = "SSH security group"
  }
}

resource "aws_eip" "web_eip" {
  instance      = aws_instance.website.id
  vpc           = true
  }

output "instance_public_ip" {
  description   = "Public IP address of the EC2 instance"
  value         = aws_instance.website.public_ip
    depends_on  = [
      aws_eip.web_eip
  ]
}
