variable "project_name" {
  type = string
}

variable "vpc" {
  description = "The VPC id that the server will reside in."
}

variable "subnet" {
  description = "The subnet id that the server will reside in."
}

variable "server_image" {
  description = "The container image of the server container."
  type        = string
}
