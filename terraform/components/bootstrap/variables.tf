variable "do_token" {
  description = "Digitalocean API token"
}
variable "do_domain" {
  description = "Your public domain"
}
variable "do_subdomain" {
  description = "Your public subdomain"
}
variable "do_region" {
  default     = "lon1"
  description = "The Digitalocean region where the faasd droplet will be created."
}
variable "letsencrypt_email" {
  description = "Email used to order a certificate from Letsencrypt"
}
