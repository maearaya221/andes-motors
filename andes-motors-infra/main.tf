terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# AMI más reciente de Amazon Linux 2 (compatible con AWS Academy)
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Usa la VPC por defecto (AWS Academy no permite crear VPCs/roles IAM nuevos)
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group: permite SSH y HTTP
resource "aws_security_group" "andes_motors_sg" {
  name        = "andes-motors-sg"
  description = "Security group para instancia de monitoreo Andes Motors"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
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
    Name = "andes-motors-sg"
  }
}

# Instancia EC2
resource "aws_instance" "andes_motors_ec2" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.andes_motors_sg.id]

  # Habilita monitoreo detallado (métricas cada 1 minuto en lugar de 5)
  monitoring = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install epel -y
              yum install -y stress httpd
              systemctl enable httpd
              systemctl start httpd
              echo "<h1>Andes Motors - Instancia de Monitoreo</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = var.instance_name
  }
}
