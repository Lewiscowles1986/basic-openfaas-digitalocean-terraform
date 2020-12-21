terraform {
  required_version = ">= 0.14"
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.3.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
  version = "2.3.0"
}
