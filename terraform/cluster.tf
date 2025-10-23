## This is just for the control plane and primary node pool.
## If there's a need for additional node pools, they will go in node_pools.tf.

resource "digitalocean_kubernetes_cluster" "cluster" {
  name     = "o5-k8s"
  region   = "sfo2"
  vpc_uuid = digitalocean_vpc.vpc_primary.id

  version = "1.33.1-do.5"

  node_pool {
    name       = "basic-4gb-2cpu-80gb-nodes"
    size       = "s-2vcpu-4gb"
    auto_scale = true
    min_nodes  = 2
    max_nodes  = 4
  }
}

output "cluster_ip" {
  value = digitalocean_kubernetes_cluster.cluster.ipv4_address
}

output "cluster_endpoint" {
  value = digitalocean_kubernetes_cluster.cluster.endpoint
}

output "cluster_status" {
  value = digitalocean_kubernetes_cluster.cluster.status
}

