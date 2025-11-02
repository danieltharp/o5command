# o5command/kubernetes

This folder contains Kubernetes deployments that concern themselves with the 
cluster itself. That is, everything other than "end-user" deployed apps that
live on the cluster. Observability tools (Loki, Grafana, etc.) concern 
themselves with the cluster and are present here. ArgoCD is an infrastructure
tool that may deploy some of those internal tools, so it is also present here.
Keycloak serves as an authn/authz layer for both infra tooling and end-user 
apps, so it is present here. Something like Nextcloud, that is simply deployed
on the infrastructure but does not interact with it as an infrastructure tool
would, is not present here, instead it goes in the `apps` folder.

Whenever possible, we use [Helm](https://helm.sh) to manage the lifecycle of 
any deployed service in the cluster.

## Installing the cluster

The cluster itself is launched out of `../terraform/cluster.tf` and built with
`terraform apply` from that folder, provided you are authorized to use the
remote Terraform Cloud workspace.

## Upgrading the cluster

Will be updated after the first upgrade of the cluster.

## Destroying the cluster

Either via the DigitalOcean control panel if just the cluster, or `terraform destroy`
from the `../terraform` folder if the entire environment is going away.

## Installing Services

Generally via Helm, and detailed in each service's `README.md` file. Note the
current order of operations is:
1. kyverno
2. cert-manager
3. gloo
4. olm
5. keycloak

## Upgrading Services

For a version update of the underlying helm chart of an application, update its
`Chart.yaml` with the new version and make the metadata version match, 
appending `-rev0` to it. For incremental updates to the Helm values, increment
the `-revN` number in the `Chart.yaml` version field.

In either case, it will generally use this format, from the app's folder:

```
% helm upgrade -n mynamespace -f values.yaml myservice .
```

Before jumping into the upgrade, you can preview changes. Install `helm-diff` via:
```
% helm plugin install https://github.com/databus23/helm-diff
```

Then you can diff an upgrade to see what will happen:
```
% helm diff upgrade -n mynamespace -f values.yaml myservice .
```

(Note the format is identical, you just add `diff`.)

You can also perform a dry run to see what Helm thinks it will do as a result
of the changes.

```
% helm upgrade -n mynamespace -f values.yaml myservice . --dry-run
```

## Uninstalling Services

Generally via Helm, and generally in the format of:

```
% helm uninstall -n mynamespace myservice
```

Note this option also has the `--dry-run` flag available to preview changes.

Any unusual uninstallations of services will be documented in that service's
`README.md` file.