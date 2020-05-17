# Using a single workspace:
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "chavo4"
    token = var.token
    
    workspaces {
      name = "remote-state"
    }
  }
}

data "terraform_remote_state" "chavo_vpc" {
  backend = "remote"

  config = {
    organization = "chavo4"
    workspaces = {
      name = "test-remote"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}

# Terraform >= 0.12
resource "aws_instance" "web" {
  ami           = "ami-0cc2b036435209c9e"
  subnet_id     = data.terraform_remote_state.chavo_vpc.outputs.chavo_subnet
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}

variable "token" {}
