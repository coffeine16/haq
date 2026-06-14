terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" { region = var.aws_region }

resource "aws_vpc" "haq" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = { Name = "haq-vpc" }
}

resource "aws_internet_gateway" "haq" {
  vpc_id = aws_vpc.haq.id
  tags   = { Name = "haq-igw" }
}

resource "aws_subnet" "haq_public" {
  vpc_id                  = aws_vpc.haq.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags = { Name = "haq-public-subnet" }
}

resource "aws_route_table" "haq" {
  vpc_id = aws_vpc.haq.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.haq.id
  }
  tags = { Name = "haq-rt" }
}

resource "aws_route_table_association" "haq" {
  subnet_id      = aws_subnet.haq_public.id
  route_table_id = aws_route_table.haq.id
}

resource "aws_security_group" "haq" {
  name        = "haq-sg"
  description = "Haq EC2 ingress"
  vpc_id      = aws_vpc.haq.id

  dynamic "ingress" {
    for_each = [22, 80, 443, 5678, 3200]
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
  tags = { Name = "haq-sg" }
}

resource "tls_private_key" "haq" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "haq" {
  key_name   = "haq-key"
  public_key = tls_private_key.haq.public_key_openssh
}

resource "local_file" "ssh_key" {
  content         = tls_private_key.haq.private_key_pem
  filename        = "${path.module}/haq-key.pem"
  file_permission = "0400"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_instance" "haq" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.haq_public.id
  vpc_security_group_ids = [aws_security_group.haq.id]
  key_name               = aws_key_pair.haq.key_name
  user_data              = file("${path.module}/user-data.sh")
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
  tags = { Name = "haq-server" }
}

resource "aws_eip" "haq" {
  instance = aws_instance.haq.id
  domain   = "vpc"
  tags     = { Name = "haq-eip" }
}
