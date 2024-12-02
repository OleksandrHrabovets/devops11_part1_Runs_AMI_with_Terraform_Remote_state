terraform {
    required_providers {
        aws = {
            source: "hashicorp/aws"
            version = "~>4.16"
        }
    }

    required_version = ">=1.2.0"
   
    backend "s3" {
      bucket         = "devops-prac"
      key            = "devops/11/part1/terraform.tfstate"
      region         = "eu-central-1"
      dynamodb_table = "devops-prac-tfstate-locking"
      encrypt        = true
    } 
}

provider "aws" {
    region = "eu-central-1"
}

data "aws_ami" "ubuntu"{
    most_recent = true

    filter {
      name = "name"
      values = ["ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"]
    }
    filter {
      name   = "root-device-type"
      values = ["ebs"]
    }
    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }

    owners = ["099720109477"]
}

resource "aws_instance" "example_server" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"

    tags = {
        Name = "DEVOPS_example_server"
    }
}

output "instance_id" {
    value = aws_instance.example_server.id
}

output "instance_ip" {
    value = aws_instance.example_server.public_ip
}