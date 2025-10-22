# o5command

A monorepo for both infrastructure and deployed applications for [SCP Wiki](https://scpwiki.com) staff and my own personal development and testing.

* All infrastructure is provisioned as code via [Terraform](https://terraform.io) on [DigitalOcean](https://digitalocean.com/), and those files can be found in the `terraform` folder.
* Core functionality of the [Kubernetes](https://kubernetes.io) cluster, including the observability stack, is located within the `kubernetes` folder. This would be things for or about the cluster itself.
* Applications on the cluster that are not considered core functionality are stored in the `apps` folder, and generally deployed via [Helm](https://helm.sh).
* Deployment is a mixture of Terraform Cloud, GitHub Actions, and [ArgoCD](https://argoproj.github.io/cd/).
* When possible, each service or deployment is documented for installation and upgrades.

More detailed README files about specifics of the project can be found deeper within the repo, closer to the relevant files.