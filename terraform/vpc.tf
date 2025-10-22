resource "digitalocean_vpc" "vpc_primary" {
  name     = "o5command-vpc-primary"
  region   = "sfo2"
  ip_range = "10.5.0.0/16"
}

output "vpc_id" {
    value = digitalocean_vpc.vpc_primary.id
}