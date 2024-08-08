resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_default_subnet" "default" {
  availability_zone = var.availability_zone

  tags = {
    Name = "Default subnet for eu-west-2a"
  }
}

resource "aws_security_group" "ecs_security_group" {
  name        = "ecs-security-group"
  description = "Allow HTTP(S) inbound traffic as well as SSH"
  vpc_id      = aws_default_vpc.default.id

  // HTTP
  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  // HTTPS
  ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  // SSH
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_&_ssh"
  }
}

resource "aws_vpc_endpoint" "ec2_to_s3" {
  vpc_id = aws_default_vpc.default.id
  service_name = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [aws_default_vpc.default.main_route_table_id]
}