# Note that you need a DIGITALOCEAN_TOKEN env var set that corresponds with a r/w token on your account.

terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}