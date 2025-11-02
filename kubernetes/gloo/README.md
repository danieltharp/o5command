Here we use [Gloo Edge](https://www.solo.io/products/gloo-edge/) to be our edge
proxy. It wraps Envoy with a lot of nice features, most of which I'm not using
given the scale of this deployment.

The general logic for service delegation is that subdomains get their own 
Virtual Service (`gloo-vs.yaml`), and paths off of the root domain just get
delegated Route Tables. This is to keep things clean from an SSL certificate
management perspective. In your day-to-day in production this would probably be
coupled with some sort of admission controller that only allows the new Virtual
Service if the domain matches what you permit.

## Installation

A correctly functioning Gloo install requires `cert-manager` as a prerequisite.
Note the `route-table.yaml` file is currently just some example routes that can
be used to check for availability of the edge, but not downstream services.

```
% k create ns gloo-system
namespace/gloo-system created

% helm repo add solo https://storage.googleapis.com/solo-public-helm
"solo" has been added to your repositories

% helm dependency build
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "jetstack" chart repository
...Successfully got an update from the "solo" chart repository
...Successfully got an update from the "kyverno" chart repository
Update Complete. ⎈Happy Helming!⎈
Saving 1 charts
Downloading gloo from repo https://storage.googleapis.com/solo-public-helm
Deleting outdated charts

% helm install gloo . -n gloo-system -f values.yaml
NAME: gloo
LAST DEPLOYED: Thu Oct 30 10:47:04 2025
NAMESPACE: gloo-system
STATUS: deployed
REVISION: 1
TEST SUITE: None

% k get all -n gloo-system
NAME                                    READY   STATUS      RESTARTS   AGE
pod/gateway-proxy-6bc8c5687c-mv2fz      1/1     Running     0          115s
pod/gloo-7798b7ff46-dtrm2               1/1     Running     0          115s
pod/gloo-resource-rollout-check-75tpv   0/1     Completed   0          114s
pod/gloo-resource-rollout-frnxl         0/1     Completed   0          115s

NAME                    TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)                                                AGE
service/gateway-proxy   LoadBalancer   <snip>           <snip>          80:31744/TCP,443:30099/TCP                             115s
service/gloo            ClusterIP      <snip>           <none>          9977/TCP,9976/TCP,9988/TCP,9966/TCP,9979/TCP,443/TCP   115s

NAME                            READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/gateway-proxy   1/1     1            1           115s
deployment.apps/gloo            1/1     1            1           115s

NAME                                       DESIRED   CURRENT   READY   AGE
replicaset.apps/gateway-proxy-6bc8c5687c   1         1         1       115s
replicaset.apps/gloo-7798b7ff46            1         1         1       115s

NAME                                    STATUS     COMPLETIONS   DURATION   AGE
job.batch/gloo-resource-rollout         Complete   1/1           25s        115s
job.batch/gloo-resource-rollout-check   Complete   1/1           29s        114s

# snipped gateway-proxy external IP is loaded into DNS records

% k apply -f route-table.yaml
virtualservice.gateway.solo.io/gloo-core-routes created

% curl http://ping.o5command.com/
ok%                                                                                                                                                                                                              
% curl http://ping.o5command.com/hello
Hello there.%

% kubectl patch -n gloo-system gateway.gateway.solo.io gateway-proxy --type merge --patch "$(cat gateway-patch.yaml)"
gateway.gateway.solo.io/gateway-proxy patched

% kubectl patch -n gloo-system gateway.gateway.solo.io gateway-proxy-ssl --type merge --patch "$(cat gateway-patch.yaml)"
gateway.gateway.solo.io/gateway-proxy-ssl patched

% kubectl patch -n gloo-system svc gateway-proxy --type merge --patch "$(cat service-patch.yaml)"
service/gateway-proxy patched
```
