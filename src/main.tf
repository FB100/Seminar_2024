terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {
}

variable "amount" {
  description = "Number of Docker Containers"
  type        = number
  default     = 3
}

resource "docker_image" "nginx" {
  name = "nginx"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  count = var.amount
  name  = "web-${count.index}"
  must_run = true
  privileged = true
  ports {
    internal = 80
    external = 8000 + count.index
  }
  ports {
    internal = 22
    external = 9000 + count.index
  }


}

output "IPAddr" {
  value = [for container in docker_container.nginx : container.network_data[0].ip_address]
}