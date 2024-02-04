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
  user_data = file("${path.module}/installdocker.sh")
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
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_block

  dynamic "ingress" {
    for_each = var.ports
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      protocol         = "tcp"
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

resource "aws_ecr_repository" "ecr" {
  for_each             = toset(var.repo_name)
  name                 = each.key
  image_tag_mutability = var.image_mutability
  encryption_configuration {
    encryption_type = var.encryption_kind
  }
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "${var.prefix}-ECR"
  }
}

# resource "aws_lb" "alb" {
#   name = "${var.prefix}-application-lb"
#   #tfsec:ignore:aws-elb-alb-not-public
#   internal                   = false
#   load_balancer_type         = "application"
#   security_groups            = [aws_security_group.web_sg.id]
#   subnets                   = [data.terraform_remote_state.network.outputs.subnet_block]
#   drop_invalid_header_fields = true
#   tags ={
#       "Name" = "${var.prefix}-ALB"
#     }

# }

# resource "aws_lb_target_group" "tg-lime" {
#   name     = "${var.prefix}-lb-target-group"
#   port     = 8080
#   protocol = "HTTP"
#   vpc_id   = data.terraform_remote_state.network.outputs.vpc_block

#   health_check {
#     path     = "/"
#     matcher  = 200
#     interval = 5
#     timeout  = 2
#   }

#   tags = {
#       "Name" = "${var.prefix}-ALBTargetGroup-lime"
#     }
# }



# #tfsec:ignore:aws-elb-http-not-used
# resource "aws_lb_listener" "alb_listener-lime" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = "80"
#   protocol          = "HTTP"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.tg-lime.arn
#   }
#   tags ={
#       "Name" = "${var.prefix}-ALBListener-lime"
#     }  
# }

# resource "aws_lb_target_group" "tg-pink" {
#   name     = "${var.prefix}-lb-target-group-pink"
#   port     = 8082
#   protocol = "HTTP"
#   vpc_id   = data.terraform_remote_state.network.outputs.vpc_block

#   health_check {
#     path     = "/"
#     matcher  = 200
#     interval = 5
#     timeout  = 2
#   }

#   tags = {
#       "Name" = "${var.prefix}-ALBTargetGroup-pink"
#     }
# }

# #tfsec:ignore:aws-elb-http-not-used
# resource "aws_lb_listener" "alb_listener-pink" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = "82"
#   protocol          = "HTTP"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.tg-lime.arn
#   }
#   tags ={
#       "Name" = "${var.prefix}-ALBListener-pink"
#     }  
# }

# resource "aws_lb_target_group" "tg-blue" {
#   name     = "${var.prefix}-lb-target-group-blue"
#   port     = 8081
#   protocol = "HTTP"
#   vpc_id   = data.terraform_remote_state.network.outputs.vpc_block

#   health_check {
#     path     = "/"
#     matcher  = 200
#     interval = 5
#     timeout  = 2
#   }

#   tags = {
#       "Name" = "${var.prefix}-ALBTargetGroup-blue"
#     }
# }



# #tfsec:ignore:aws-elb-http-not-used
# resource "aws_lb_listener" "alb_listener-blue" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = "81"
#   protocol          = "HTTP"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.tg-blue.arn
#   }
#   tags ={
#       "Name" = "${var.prefix}-ALBListener"
#     }  
# }