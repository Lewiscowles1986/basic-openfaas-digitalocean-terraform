resource "random_password" "password" {
  length = 16
  special = true
  override_special = "_-#"
}

resource "digitalocean_droplet" "faasd" {
  region = var.do_region
  image  = "ubuntu-18-04-x64"
  name   = "faasd"
  size = "s-1vcpu-1gb"
  user_data = data.template_file.cloud_init.rendered
  monitoring = var.monitoring
  ipv6 = var.ipv6
  backups = var.backups
  private_networking = var.private_networking
}

resource "digitalocean_record" "faasd" {
  domain = var.do_domain
  type   = "A"
  name   = "faasd"
  value  = digitalocean_droplet.faasd.ipv4_address
  # Only creates record if do_create_record is true
  count  = var.do_create_record == true ? 1 : 0
  ttl = var.dns_ttl
}

resource "digitalocean_record" "faasd_v6" {
  domain = var.do_domain
  type   = "AAAA"
  name   = "faasd"
  value  = digitalocean_droplet.faasd.ipv6_address
  # Only creates record if do_create_record is true
  count  = var.do_create_record && var.ipv6 == true ? 1 : 0
  ttl    = var.dns_ttl
}
