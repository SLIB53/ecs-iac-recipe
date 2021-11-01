locals {
  project_name = "my-service"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

provider "aws" {
  region = "us-east-2" # TODO: make configurable

  default_tags {
    tags = {
      Project = local.project_name
    }
  }
}

resource "aws_ecr_repository" "my_service_repository" {
  name = "my-service"
}

module "server" {
  source = "./modules/server"

  project_name = local.project_name

  vpc    = aws_vpc.main.id
  subnet = aws_subnet.public_subnet.id

  server_image = "${aws_ecr_repository.my_service_repository.repository_url}:latest"
}
