# o5command/kubernetes/cert-manager

Cert-manager is what handles obtaining and rotating TLS certificates for the
cluster. It is a prerequisite for almost anything that interacts with the
Internet. A Chart and values files are provided for a minimal HA configuration.
Do note that the installation process is not everything you need to do, there
is more to do once Gloo is installed.

## Installation

```
% helm repo add jetstack https://charts.jetstack.io --force-update
"jetstack" has been added to your repositories

% helm dependency build
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "jetstack" chart repository
...Successfully got an update from the "kyverno" chart repository
Update Complete. ⎈Happy Helming!⎈
Saving 1 charts
Downloading cert-manager from repo https://charts.jetstack.io
Deleting outdated charts

% kubectl create namespace cert-manager
namespace/cert-manager created

% helm install cert-manager . -f values.yaml
NAME: cert-manager
LAST DEPLOYED: Wed Oct 29 10:43:19 2025
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

## Additional Configuration after Gloo installation

Once [Gloo](../gloo/README.md) is installed, cert-manager starts to become more
functional. Gloo will spin up a gateway proxy with an external IP that you can
assign hostnames to via DNS, and begin issuing certificates for them, which Gloo
will retrieve and use automatically. Note the order of operations is quite
important, kubernetes will bark at you if you apply things out of order.

```
% k apply -f service.yaml
service/acme-solver created

% k apply -f gloo-routes.yaml
routetable.gateway.solo.io/cert-manager-routes created

% k describe routetable -n gloo-system cert-manager-routes
Name:         cert-manager-routes
Namespace:    gloo-system
Labels:       <none>
Annotations:  <none>
API Version:  gateway.solo.io/v1
Kind:         RouteTable
Metadata:
  Creation Timestamp:  2025-10-30T17:15:46Z
  Generation:          2
  Resource Version:    512714
  UID:                 de413cfa-d6be-4d3b-b0b5-22257c4fa416
Spec:
  Routes:
    Matchers:
      Prefix:  /.well-known/acme-challenge/
    Route Action:
      Single:
        Upstream:
          Name:       acme-solver
          Namespace:  gloo-system
Status:
  Statuses:
    Gloo - System:
      Reported By:  gloo
      State:        Accepted  # This is what we want to see.
      Subresource Statuses:
        *v1.Proxy.gateway-proxy_gloo-system:
          Reported By:  gloo
          State:        Accepted
Events:                 <none>

% k apply -f cluster-issuer.yaml
clusterissuer.cert-manager.io/letsencrypt created
```

## Uninstallation

```
% helm uninstall cert-manager
These resources were kept due to the resource policy:
[CustomResourceDefinition] challenges.acme.cert-manager.io
[CustomResourceDefinition] orders.acme.cert-manager.io
[CustomResourceDefinition] certificaterequests.cert-manager.io
[CustomResourceDefinition] certificates.cert-manager.io
[CustomResourceDefinition] clusterissuers.cert-manager.io
[CustomResourceDefinition] issuers.cert-manager.io

release "cert-manager" uninstalled
```