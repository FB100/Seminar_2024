terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
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
  publish_all_ports = true
  command = [
    "tail",
    "-f",
    "/dev/null"
  ]

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.network_data[0].ip_address},'  playbook.yml"
  }
}



output "IPAddr" {
  value = [for container in docker_container.ubuntu : container.network_data[0].ip_address]
}