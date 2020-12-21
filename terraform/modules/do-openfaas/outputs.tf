output "droplet_ip" {
  value = digitalocean_droplet.faasd.ipv4_address
}

output "droplet_ipv6" {
  value = digitalocean_droplet.faasd.ipv6_address
}

output "gateway_url" {
  value = "https://${var.do_subdomain}.${var.do_domain}/"
}

output "password" {
    value = random_password.password.result
}

output "login_cmd" {
  value = "faas-cli login -g https://${var.do_subdomain}.${var.do_domain}/ -p ${random_password.password.result}"
}
