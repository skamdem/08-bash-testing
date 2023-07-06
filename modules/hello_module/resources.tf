
resource "aws_security_group" "server_sg" {
  name = "${local.resources_tag}-sg"
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.server_sg.id

  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_instance" "server" {
  ami             = var.instance_ami_id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.server_sg.name]
  user_data       = <<-EOF
        #!/bin/bash
        echo "Hello from our instance" > index.html
        python3 -m http.server 8080 &
        EOF

  tags = {
    Name        = "${local.resources_tag}-instance"
    "Terraform" = "Yes"
  }
}

locals {
  resources_tag = "hello-module"
}