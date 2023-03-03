provider "aws" {
    region = var.AWS_REGION
    access_key = var.AWS_ACCESS_KEY
    secret_key = var.AWS_SECRET_KEY
}
data "aws_ami" "ubuntu-ami" {
most_recent = true
owners = ["099720109477"] # Canonical
filter {
name = "name"
values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
}
filter {
name = "root-device-type"
values = ["ebs"]
}
filter {
name = "virtualization-type"
values = ["hvm"]
}
filter {
name = "architecture"
values = ["x86_64"]
}
}
resource "aws_security_group" "instance_sg" {
name = "terraform-test-sg"
egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
ingress {
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
ingress {
description = "SSH from VPC"
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
}
resource "aws_key_pair" "my-ssh-key" {
key_name = "mykey"
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDfR3I2NvEhOx4DWDMRBt0c7NB1hHLD6/CsAknu7TKIl+wl05pzr+vS3q0PWsk/ruW3+Ddccitsff1WEdvgkIxZ/IV3RuvhmulOnNlcwbq22qcNzosm1pNiLg2+62z5x+JrvmvHKoxVkKsrjzrAQ3MOcIMJ1HuEspHTTpzfCZDzRdLVotPENiQmUCuMd9L5Cb21RvkPFpMfBn7JD6hH3FXV4KOnShhRXdkBd+mmnaRLmlPHT3443XiIb/d0BaJ7iE2+7opdDgp2rQY7GIRXECChM/fGON3Kk4ttT4iCKWq32yd5/EQMA7U6jN+MmHezqf7ljYO5QGNHzgPhnctsPJsjbO0jCQ4gAw5kIvsZsgUjFqvCT5n2gWdNrISRGYGjeYUAi6lBQFSApCrfvMtpfPk6A1pvqi0aEZ8DQj6Mh1uuCsJ1VUJwlREZJzbZBNT+5+8fXXw8SKOgooqF4ore+ZsXMDy+XrgMxlLbWUl3lSHoWis1fCSot54+EC6lgDEBFAM= root@root"
}
resource "aws_instance" "my_ec2_instance" {
ami = data.aws_ami.ubuntu-ami.id
instance_type = "t2.micro"
vpc_security_group_ids = [aws_security_group.instance_sg.id]
key_name = aws_key_pair.my-ssh-key.key_name
user_data = <<-EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
sudo echo "<h1>Hello Terraform</h1>" > /var/www/html/index.html
EOF
tags = {
Name = "missou-terraform"
}
}
output "public_ip" {
value = aws_instance.my_ec2_instance.public_ip
}