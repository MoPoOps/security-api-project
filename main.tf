#1 telling Terraform that I am using AWS as my provider
provider "aws" {
  region = "eu-central-1" 
}

#2 the data Source to find the operating system
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # the official ID for ubuntu

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

#3 security group
resource "aws_security_group" "api_sg" {
    name        = "security_api_firewall"
    description = "Allow inbound HTTP traffic for the API"

    # ingress means the incoming traffic
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # from any ip on the internet
    }

    #egress means outgoing traffic#
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1" # this means all protocols
        cidr_blocks = ["0.0.0.0/0"] # to allow the server to reach the internet to download the docker
    }
}

#4 resource to build the actual server
resource "aws_instance" "api_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  # to attach the firewall i built to this specific server
  vpc_security_group_ids = [aws_security_group.api_sg.id]

  #5 boot script (user data)
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y docker.io
              sudo systemctl start docker
              sudo docker run -d -p 80:8080 mopodevops/security-api:v1
              EOF

  tags = {
    Name = "Security-API-Server"
  }
}