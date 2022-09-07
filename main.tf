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

 // this only gets added to resources created by terraform. 
 // if there are dynamic resources (e.g EC2 instances created by Autoscaling groups), the new resources won't get tagged
 // follow https://learn.hashicorp.com/tutorials/terraform/aws-default-tags?in=terraform/aws#propagate-default-tags-to-auto-scaling-group to mitigate this

  default_tags {     
    tags = {
      uuid = "BvZPganedGfYklJIvCIFX4"
    }
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-0bcce266670ea4183"
  instance_type = "t2.micro"
  subnet_id     = "subnet-df32e686"

  tags = {
    Name = var.instance_name
  }
}
