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
  //count      = var.amount
  name = "web"//"web-${count.index}"
  must_run   = true
  privileged = true
  ports {
    internal = 80
    external = 8000 //+ count.index
  }
  ports {
    internal = 22
    external = 7000
  }
}
/*

resource "ssh_resource" "init" {
  host  = docker_container.nginx
  when  = "create"
  agent = true
  # An ssh-agent with your SSH private keys should be running
  # Use 'private_key' to set the SSH key otherwise

  # Try to complete in at most 15 minutes and wait 5 seconds between retries
  timeout     = "15m"
  retry_delay = "5s"

  file {
    content     = "echo Hello world"
    destination = "/tmp/hello.sh"
    permissions = "0700"
  }

  commands = [
    "/tmp/hello.sh"
  ]
}
*/


/*
output "IPAddr" {
  value = [for container in docker_container.nginx : container.network_data[0].ip_address]
}
*/
