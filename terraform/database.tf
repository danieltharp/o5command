resource "digitalocean_database_cluster" "postgres" {
  name       = "o5-postgres"
  engine     = "pg"
  version    = "17"
  size       = "db-intel-1vcpu-1gb"
  region     = "sfo2"
  node_count = 1
}

output "postgres_host" {
  value = digitalocean_database_cluster.postgres.host
}

output "postgres_private_host" {
  value = digitalocean_database_cluster.postgres.private_host
}

output "postgres_database" {
  value = digitalocean_database_cluster.postgres.database
}

output "postgres_username" {
  value = digitalocean_database_cluster.postgres.user
}

output "postgres_password" {
  value     = digitalocean_database_cluster.postgres.password
  sensitive = true
}