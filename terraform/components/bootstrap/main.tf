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
  do_token          = vars.do_token
  do_domain         = vars.do_domain
  do_subdomain      = vars.do_subdomain
  letsencrypt_email = vars.letsencrypt_email
  do_create_record = true
  do_region         = vars.do_region
}