provider "aws" {
  region     = "eu-west-3"
  access_key = "AKIARTZ64IGLAMXBBDOJ"
  secret_key = "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"
}
resource "aws_security_group" "instance_sg" {
  name = "terraform-test-sg-missou"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "my_ec2_instance" {
  ami                    = "ami-05b457b541faec0ca"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  user_data              = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y apache2
    sudo systemctl start apache2
    sudo systemctl enable apache2
    echo "<h1>Hello Terraform</h1>" > /var/www/html/index.html
    EOF
  tags = {
    Name = "missou-Terraform Formation "
  }
}


