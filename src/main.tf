terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {
  // for Windows
  // host = "npipe:////.//pipe//docker_engine"
}

variable "amount_docker_containers" {
  description = "Number of Docker Containers"
  type        = number
  default     = 3
}

resource "docker_image" "ubuntu" {
  name         = "ubuntu:precise"
}

resource "docker_container" "ubuntu" {
  image = docker_image.ubuntu.image_id
  count = 2
  name  = "web-${count.index}"
  must_run = true

  ports {
    internal = 22
    external = 2200 + count.index
  }

  command = [
    "sh", "-c",
    "apt-get update && apt-get install -y openssh-server"
  ]

  connection {
    type     = "ssh"
    host     = self.network_data[0].ip_address
    port     = 2200 + count.index
    user     = "root"
    password = "password"
  }

  provisioner "local-exec" {
    command = "sleep 10"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Container is set up with SSH!'"
    ]
  }

}

output "IPAddr" {
  value = [for container in docker_container.ubuntu : container.network_data[0].ip_address]
}