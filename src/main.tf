terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
    ssh = {
      source  = "loafoe/ssh"
      version = "2.7.0"
    }
  }
}

provider "docker" {}

variable "amount" {
  description = "Number of Docker Containers"
  type        = number
  default     = 3
}

resource "docker_image" "ubuntu" {
  name = "ubuntu"
  build {
    context = "."
  }
}

resource "docker_container" "ubuntu" {
  image = docker_image.ubuntu.image_id
  count      = var.amount
  name = "web-${count.index}"
  must_run   = true
  privileged = true
  ports {
    internal = 80
    external = 8000 + count.index
  }
  ports {
    internal = 22
    external = 7000 + count.index
  }


}

output "IPAddr" {
  value = [for container in docker_container.ubuntu : container.network_data[0].ip_address]
}