terraform {
  required_version = ">= 0.14"
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.3.0"
    }
  }
}

module "digitalocean_basic_openfaas" {
  source            = "../../modules/do-openfaas/"
  do_token          = var.do_token
  do_create_record  = true
  do_domain         = var.do_domain
  do_subdomain      = var.do_subdomain
  do_region         = var.do_region
  letsencrypt_email = var.letsencrypt_email
}