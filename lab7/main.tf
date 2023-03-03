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
name = "terraform-test-sg-missou"
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
key_name = "mykey-missou"
public_key = file("/home/dba/terraform/terraform.pub")
}
resource "aws_instance" "my_ec2_instance" {
#count = var.instance_count
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
#Name = "${var.is_prod[count.index] ? "prod-ec2-missou" : "test-ec2-missou"}"
}
#provisioner "local-exec" {
#command = "echo ${aws_instance.my_ec2_instance.public_ip} > ip_address.txt"
#}
  connection {
  type = "ssh"
  user = "ubuntu"
  private_key = file("/home/dba/terraform/terraform")
  host = self.public_ip
  }
#provisioner "remote-exec" {
#inline = [
#"sudo apt-get -f -y update",
#"sudo apt-get install -f -y apache2",
#"sudo systemctl start apache2",
#"sudo systemctl enable apache2",
#"sudo sh -c 'echo \"<h1>Hello Terraform missou</h1>\" > /var/www/html/index.html'",
#]
#} 
  provisioner "remote-exec" {
      script = "./apps/script.sh"
    }

  provisioner "file" {
      source = "./apps/index.php"
      destination = "/tmp/index.php"
    }
    
  provisioner "remote-exec" {
    inline =[
      "sudo mv /var/www/html/index.html /var/www/html/index1.html",
      "sudo cp /tmp/index.php /var/www/html/index.php"
    ]
  }
  provisioner "local-exec" {
    on_failure = continue
    command = "echo ${aws_instance.my_ec2_instance.public_ip} > ip_address.txt"
  }
}
#output "key_name" {
  #value = "${aws_key_pair.my-ssh-key.*.key_name}"
 #value = [for key_name in aws_key_pair.my-ssh-key.*.key_name : "${key_name}"]
#}



