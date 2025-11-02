# o5command/kubernetes/keycloak

[Keycloak](https://www.keycloak.org/) is an identity provider and will serve as
the Single Sign-On (SSO) platform for platform users. This will include not just
access to apps like email, but cluster observability tools. It is deployed via
an operator and thus needs `olm` installed as a prerequisite, which needs
`cert-manager` installed as its own prerequisite. The main application also 
requires an ingress and load balancer, so `gloo` is also a prerequisite.

## Installation of Operator

Follow [Keycloak's docs](https://www.keycloak.org/operator/installation) on
installing the operator.

```
% kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.4.2/kubernetes/keycloaks.k8s.keycloak.org-v1.yml
customresourcedefinition.apiextensions.k8s.io/keycloaks.k8s.keycloak.org created

% kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.4.2/kubernetes/keycloakrealmimports.k8s.keycloak.org-v1.yml
customresourcedefinition.apiextensions.k8s.io/keycloakrealmimports.k8s.keycloak.org created

% kubectl create namespace keycloak
namespace/keycloak created

% kubectl -n keycloak apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.4.2/kubernetes/kubernetes.yml
serviceaccount/keycloak-operator created
clusterrole.rbac.authorization.k8s.io/keycloak-operator-clusterrole created
clusterrole.rbac.authorization.k8s.io/keycloakrealmimportcontroller-cluster-role created
clusterrole.rbac.authorization.k8s.io/keycloakcontroller-cluster-role created
clusterrolebinding.rbac.authorization.k8s.io/keycloak-operator-clusterrole-binding created
role.rbac.authorization.k8s.io/keycloak-operator-role created
rolebinding.rbac.authorization.k8s.io/keycloak-operator-role-binding created
rolebinding.rbac.authorization.k8s.io/keycloakrealmimportcontroller-role-binding created
rolebinding.rbac.authorization.k8s.io/keycloakcontroller-role-binding created
rolebinding.rbac.authorization.k8s.io/keycloak-operator-view created
service/keycloak-operator created
deployment.apps/keycloak-operator created
```

Once the operator is installed, you can continue.

## Installation, Part II

We're going to follow the order of operation of the [docs](https://www.keycloak.org/operator/basic-deployment)
to cause the least amount of problems with the deployment. This has us start
with the database. We've deployed one via Terraform that's outside the cluster,
but it's not configured. You will need to retrieve the credentials from the
DigitalOcean control panel, get connected, and create a keycloak database and
credentials for the service account to feed to Keycloak. Since the database is
on the same VPC as the cluster, we should use the internal hostname for the
server when possible so we can be faster, more secure, and spend less money on
traffic. You can use [JetBrains DataGrip](https://www.jetbrains.com/datagrip/)
for free to make this step easier. To reiterate:

- Get connected to the Postgres database.
- Make a database called `keycloak`.
- Create a database user with full access to the `keycloak` database.
- Grant access to the public schema on the database to your user.
- Store the credentials for later use.

```
> CREATE DATABASE keycloak WITH OWNER doadmin;
> CREATE USER keycloak_user WITH ENCRYPTED PASSWORD '<snip>';
> GRANT ALL PRIVILEGES ON DATABASE keycloak TO keycloak_user;
> GRANT ALL PRIVILEGES ON SCHEMA public TO keycloak_user;
```

Setting the owner as `doadmin` ensures manual intervention of the database is
always available, should we need it as a last resort.

Since the docs are quite agnostic with regard to what other technologies
Keycloak is put in play with, we deviate from their reference implementation
specifically around ingress and TLS. We will reverse proxy the traffic from
Gloo and also let it and cert-manager handle TLS. Let's instead begin by
creating the secret needed for Keycloak to connect to our postgres database.

```
% k create secret generic keycloak-db-secret --from-literal=username=keycloak_user --from-literal=password=<snip> -n keycloak
secret/keycloak-db-secret created

% k apply -n keycloak -f keycloak.yaml
keycloak.k8s.keycloak.org/keycloak created
```

It should take a few minutes to fire up. You can check for any relevant logs
with `k logs keycloak-0 -n keycloak` every few seconds.

Now apply the `gloo-vs-http.yaml` file to allow cert-manager to install a TLS
certificate for the auth and admin domains, then request the certificate.

```
% k apply -f gloo-vs-http.yaml
virtualservice.gateway.solo.io/keycloak-auth-http-vs created
virtualservice.gateway.solo.io/keycloak-admin-http-vs created

% k apply -f certificate.yaml
Warning: spec.privateKey.rotationPolicy: In cert-manager >= v1.18.0, the default value changed from `Never` to `Always`.
certificate.cert-manager.io/keycloak-auth-certificate created

% k get certificate -n cert-manager
NAME                         READY   SECRET                       AGE
keycloak-admin-certificate   True    keycloak-admin-certificate   25s
keycloak-auth-certificate    True    keycloak-certificate         25s

% k apply -f gloo-vs-public.yaml
virtualservice.gateway.solo.io/keycloak-auth-vs created

% k apply -f gloo-vs-admin.yaml
virtualservice.gateway.solo.io/keycloak-admin-vs created
```

Keycloak should now be reachable at the domain in the admin virtual service.

## Logging in

```
% k get secret keycloak-initial-admin -n keycloak -oyaml
apiVersion: v1
data:
  password: <snip>
  username: dGVtcC1hZG1pbg==
kind: Secret
metadata:
  annotations:
    javaoperatorsdk.io/previous: e00cfa57-9668-44f4-8c72-523ce7818ec4
  creationTimestamp: "2025-10-30T20:16:44Z"
  labels:
    app: keycloak
    app.kubernetes.io/instance: keycloak
    app.kubernetes.io/managed-by: keycloak-operator
  name: keycloak-initial-admin
  namespace: keycloak
  ownerReferences:
  - apiVersion: k8s.keycloak.org/v2alpha1
    kind: Keycloak
    name: keycloak
    uid: dec4d70c-f5a2-4513-a700-02b95d7aaadc
  resourceVersion: "579112"
  uid: e44e6f4a-d18f-49aa-a7c9-8838aaea1dd9
type: kubernetes.io/basic-auth
```

Note both the data values are base-64 encoded and need to be decoded to get the initial credentials.

```
% echo 'dGVtcC1hZG1pbg==' | base64 -d
temp-admin
```

You can then go to https://auth.o5command.com/admin/master/console and use the
temporary credentials to get signed in. If they do not work, it's been too long
since keycloak was initially installed and when you got to this point, and you
will need to `k delete -f keycloak.yaml`, delete all tables in the database,
and `k apply -f keycloak.yaml` again. Then repeat the steps to get the secrets
and try again.

Once logged in, create a break-glass account for an admin, set a credential for
it, give it the realm role mapping of `admin`, log in with it, and delete the
`temp-admin` account.