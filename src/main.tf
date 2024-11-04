terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {
  host    = "npipe:////.//pipe//docker_engine"
}

variable "amount_docker_containers" {
  description = "Number of Docker Containers"
  type        = number
  default     = 3
}


resource "docker_image" "ubuntu" {
  name         = "ubuntu:precise"
  keep_locally = false
}

resource "docker_container" "web" {
  image = docker_image.ubuntu.image_id
  count = 2
  name  = "web-${count.index}"
}

output "IPAddr" {
  value = [for container in docker_container.web: container.network_data[0].ip_address]
}