output "droplet_ip" {
  value = module.digitalocean_basic_openfaas.droplet_ip
}

output "droplet_ipv6" {
  value = module.digitalocean_basic_openfaas.droplet_ipv6
}

output "gateway_url" {
  value = module.digitalocean_basic_openfaas.gateway_url
}

output "password" {
  value = module.digitalocean_basic_openfaas.password
}

output "login_cmd" {
  value = module.digitalocean_basic_openfaas.login_cmd
}
