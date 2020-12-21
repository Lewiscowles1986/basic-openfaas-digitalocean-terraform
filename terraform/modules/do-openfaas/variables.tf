variable "do_token" {
  description = "Digitalocean API token"
}
variable "do_domain" {
  description = "Your public domain"
}
variable "letsencrypt_email" {
  description = "Email used to order a certificate from Letsencrypt"
}
variable "do_subdomain" {
  default = "faasd"
  description = "Your public subdomain"
}
variable "do_create_record" {
  default     = false
  description = "Whether to create a DNS record on Digitalocean"
}
variable "do_region" {
  default     = "lon1"
  description = "The Digitalocean region where the faasd droplet will be created."
}
variable "ssh_key_file" {
  default     = "~/.ssh/id_rsa.pub"
  description = "Path to the SSH public key file"
}
variable "ipv6" {
  default     = true
  description = "Whether to enable IPV6 for the droplet"
}
variable "backups" {
  default     = false
  description = "Whether to enable Backups for the droplet"
}
variable "monitoring" {
  default     = false
  description = "Whether to enable Monitoring for the droplet"
}
variable "private_networking" {
  default     = false
  description = "Whether to enable Private networking for the droplet"
}
variable "dns_ttl" {
  default     = 300
  description = "Controls the TTL for DNS. Defaults to 5 minutes in seconds for experimentation."
}
