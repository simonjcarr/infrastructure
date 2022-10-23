variable "public_key_file" {}
variable "hcloud_network" {}
variable "hcloud_subnet" {}
variable "hcloud_network_format" {}
variable "network_zone" {}
variable "image" {}
variable "image_type" {}

resource "hcloud_ssh_key" "web_service" {
  name = "Web Service Hetzner RSA"
  public_key = file(var.public_key_file)
}

resource "hcloud_network" "web_service_network" {
  name = "web-service-network"
  ip_range = var.hcloud_network
}

resource "hcloud_network_subnet" "web_service_subnet" {
  type = "cloud"
  network_id = hcloud_network.web_service_network.id
  network_zone = var.network_zone
  ip_range = var.hcloud_subnet
}

resource "hcloud_server" "nginx_front_end" {
  name = "nginx-front-end"
  image = var.image
  server_type = var.image_type
  
  network {
    network_id = hcloud_network.web_service_network.id
    ip = "10.0.2.2"
  }

  ssh_keys = [hcloud_ssh_key.web_service.id]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
}

resource "hcloud_server" "docker_back_end" {
  name = "docker-back-end"
  image = var.image
  server_type = var.image_type
  
  network {
    network_id = hcloud_network.web_service_network.id
    ip = "10.0.2.3"
  }

  ssh_keys = [hcloud_ssh_key.web_service.id]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
}