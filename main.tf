terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0bcce266670ea4183"
  instance_type = "t2.micro"
  subnet_id     = "subnet-df32e686"

  tags = {
    Name = var.instance_name
    uuid = "BvZPganedGfYklJIvCIFX4"
  }
}
