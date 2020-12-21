# basic-openfaas-digitalocean-terraform
OpenFaaS DigitalOcean Terraform

## Pre-requisites

* Install terraform
* Sign up to DigitalOcean
* Install git
* Ensure your DNS nameservers for the domain in question are held by digitalocean

> **NOTE:** Yes that really should be all you need

## Steps

1. `git clone https://github.com/Lewiscowles1986/basic-openfaas-digitalocean-terraform.git`
2. `cd basic-openfaas-digitalocean-terraform/terraform/components/bootstrap`
3. `terraform init`
4. `terraform plan` (you will be asked for variables, you can supply them using a tfvars file, but it's out of scope here)
5. `terraform apply` (see prior point for note about variables)

## Management

This example contains a basic certbot rotation for certificates.
They *SHOULD NOT* expire and *SHOULD NOT* need to be renewed. No warranty or representation of merchantability is provided.

It was part of setting up a minimum viable FaaS-D on DigitalOcean and likely should not be used in production

## Notes / Future-work

* Setup digitalocean loadbalancer, tell it to get the certs
* Setup do kubernetes as part of this and configure faasd to use that cluster
* It would be trivially simple to move the certbot to your local machine and distribute with terraform / cloud-init.
* Reduce boot times or work out "ready-state" so this can be blue-green deployed without downtime

## Thanks

To Alex Ellis & OpenFaaS team. Most of this is from their own examples, but those miss letsencrypt & SSL control details, 
and make the user do more steps, and make choices I did not like.

Consider sponsoring OpenFaaS and it's creators, and upstream to them if you care about OpenSource or even just longevity.
I've been working with OpenFaaS since 2017. Most of what I do with their framework is made possible by them.
