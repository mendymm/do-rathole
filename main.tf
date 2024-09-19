terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    random = {
      source = "opentofu/random"
      version = "3.6.2"
    }
    local = {
      source = "opentofu/local"
      version = "2.5.1"
    }
  }
}

resource "random_string" "domain_name" {
  length = 12
  lower = true
  special = false
  numeric = false
  upper = false

}

# Set the variable value in *.tfvars file
# or using -var="do_token=..." CLI option
variable "do_token" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

# Create a web server
resource "digitalocean_droplet" "rathole_host" {
  image = "ubuntu-24-04-x64"
  name = "rathole"
  region = "tor1"
  size = "s-1vcpu-1gb"
  ssh_keys = [ 35605770 ]
  user_data = file("${path.module}/cloud-config.yaml")
}

# Create a new domain
resource "digitalocean_domain" "rathole_domain" {
  name       = "rathole-${random_string.domain_name.id}.do.mendy.dev"
  ip_address = digitalocean_droplet.rathole_host.ipv4_address
}

resource "local_file" "domain_name" {
  content  = "${digitalocean_domain.rathole_domain.id}"
  filename = "${path.module}/rathole-domain.txt"
}

