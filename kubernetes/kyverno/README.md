[Kyverno](https://kyverno.io/) is a way to standardize admission controllers 
and policy on your cluster using relatively simple declarative statements.
Simply put, you can use it to forbid certain types of things from being 
launched on your cluster. It's the first thing I install on the cluster and
the first policy is one to disallow resources from being created in the
default namespace, as an easy way to catch problems before they're problems.

----

```
% helm repo update
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "kyverno" chart repository
Update Complete. ⎈Happy Helming!⎈

% helm dependency build
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "kyverno" chart repository
Update Complete. ⎈Happy Helming!⎈
Saving 1 charts
Downloading kyverno from repo https://kyverno.github.io/kyverno/
Deleting outdated charts

% helm install kyverno -n kyverno . -f values.yaml --create-namespace
NAME: kyverno
LAST DEPLOYED: Fri Oct 24 10:30:42 2025
NAMESPACE: kyverno
STATUS: deployed
REVISION: 1

% k apply -n kyverno -f policies/disallow_default_namespace.yaml
clusterpolicy.kyverno.io/disallow-default-namespace created

% k run nginx --image=nginx
Error from server: admission webhook "validate.kyverno.svc-fail" denied the request:

resource Pod/default/nginx was blocked due to the following policies

disallow-default-namespace:
  validate-namespace: 'validation error: Using the default namespace is not allowed.
    rule validate-namespace failed at path /metadata/namespace/'
```