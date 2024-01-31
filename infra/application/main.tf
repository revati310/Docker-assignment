provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "terraform_remote_state" "network" { 
  backend = "s3"
  config = {
    bucket = "${var.prefix}-assignment1-revati"
    key    = "network/terraform.tfstate" 
    region = "us-east-1"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_instance" "my_amazon" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.web_key.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.subnet_block
  security_groups             = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  root_block_device {
    encrypted = true
  }

  lifecycle {
    create_before_destroy = true
  }
  tags = {
      "Name" = "${var.prefix}-server"
    }
  
}


resource "aws_key_pair" "web_key" {

 key_name   = var.prefix
  public_key = file("${var.prefix}-key.pub")
}

resource "aws_security_group" "web_sg" {
  name        = "allow_http_ssh"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id
  
  dynamic "ingress" {
    for_each = var.ports
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      cidr_blocks =  ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      protocol        = "tcp"
    }
  }

  ingress {
    description      = "SSH from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    
        "Name" = "${var.prefix}-server-sg"
    }
  
}
