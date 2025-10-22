# o5command/terraform

This is a rather simple way to deploy via [Terraform](https://terraform.io). Each resource, or small logical grouping of resources, is in its own .tf file. I find that makes for more intuitive diffs and PRs. State and backend are managed by Terraform Cloud. Kubernetes will request a load balancer and I'll allow the cluster and DigitalOcean to provision it rather than declare it here, as it's still within the Infrastructure-as-code paradigm but is more intuitive to understand the purpose of it as a Kubernetes object rather than a Terraform one.

Using this repo with Terraform Cloud requires a `DIGITALOCEAN_TOKEN` variable set at TF Cloud, with a value of a read-write DigitalOcean API Key.