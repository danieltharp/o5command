# o5command/kubernetes/olm

This is the Operator Lifecycle Manager, used to handle the deployment of 
[Keycloak](../keycloak/README.md) Operator. The recommended manual installation
of OLM is via two `kubectl` apply commands, so I've just included them in a .sh file.

## Installation

Install [operator-sdk](https://sdk.operatorframework.io/docs/installation/) and
have a valid kubeconfig set to connect to the cluster, then:

```
% operator-sdk olm install
INFO[0000] Fetching CRDs for version "0.28.0"
INFO[0000] Fetching resources for resolved version "v0.28.0"
INFO[0001] Checking for existing OLM CRDs
INFO[0002] Checking for existing OLM resources
INFO[0002] Installing OLM CRDs...
INFO[0002]   Creating CustomResourceDefinition "catalogsources.operators.coreos.com"
INFO[0003]   CustomResourceDefinition "catalogsources.operators.coreos.com" created
INFO[0003]   Creating CustomResourceDefinition "clusterserviceversions.operators.coreos.com"
INFO[0005]   CustomResourceDefinition "clusterserviceversions.operators.coreos.com" created
INFO[0005]   Creating CustomResourceDefinition "installplans.operators.coreos.com"
INFO[0006]   CustomResourceDefinition "installplans.operators.coreos.com" created
INFO[0006]   Creating CustomResourceDefinition "olmconfigs.operators.coreos.com"
INFO[0007]   CustomResourceDefinition "olmconfigs.operators.coreos.com" created
INFO[0007]   Creating CustomResourceDefinition "operatorconditions.operators.coreos.com"
INFO[0008]   CustomResourceDefinition "operatorconditions.operators.coreos.com" created
INFO[0008]   Creating CustomResourceDefinition "operatorgroups.operators.coreos.com"
INFO[0009]   CustomResourceDefinition "operatorgroups.operators.coreos.com" created
INFO[0009]   Creating CustomResourceDefinition "operators.operators.coreos.com"
INFO[0010]   CustomResourceDefinition "operators.operators.coreos.com" created
INFO[0010]   Creating CustomResourceDefinition "subscriptions.operators.coreos.com"
INFO[0012]   CustomResourceDefinition "subscriptions.operators.coreos.com" created
INFO[0013] Creating OLM resources...
INFO[0013]   Creating Namespace "olm"
INFO[0014]   Namespace "olm" created
INFO[0014]   Creating Namespace "operators"
INFO[0015]   Namespace "operators" created
INFO[0015]   Creating ServiceAccount "olm/olm-operator-serviceaccount"
INFO[0016]   ServiceAccount "olm/olm-operator-serviceaccount" created
INFO[0016]   Creating ClusterRole "system:controller:operator-lifecycle-manager"
INFO[0017]   ClusterRole "system:controller:operator-lifecycle-manager" created
INFO[0017]   Creating ClusterRoleBinding "olm-operator-binding-olm"
INFO[0018]   ClusterRoleBinding "olm-operator-binding-olm" created
INFO[0018]   Creating OLMConfig "cluster"
INFO[0019]   OLMConfig "cluster" created
INFO[0019]   Creating Deployment "olm/olm-operator"
INFO[0021]   Deployment "olm/olm-operator" created
INFO[0021]   Creating Deployment "olm/catalog-operator"
INFO[0022]   Deployment "olm/catalog-operator" created
INFO[0022]   Creating ClusterRole "aggregate-olm-edit"
INFO[0023]   ClusterRole "aggregate-olm-edit" created
INFO[0023]   Creating ClusterRole "aggregate-olm-view"
INFO[0024]   ClusterRole "aggregate-olm-view" created
INFO[0024]   Creating OperatorGroup "operators/global-operators"
INFO[0025]   OperatorGroup "operators/global-operators" created
INFO[0025]   Creating OperatorGroup "olm/olm-operators"
INFO[0026]   OperatorGroup "olm/olm-operators" created
INFO[0026]   Creating ClusterServiceVersion "olm/packageserver"
INFO[0027]   ClusterServiceVersion "olm/packageserver" created
INFO[0027]   Creating CatalogSource "olm/operatorhubio-catalog"
INFO[0028]   CatalogSource "olm/operatorhubio-catalog" created
INFO[0028] Waiting for deployment/olm-operator rollout to complete
INFO[0029]   Deployment "olm/olm-operator" successfully rolled out
INFO[0029] Waiting for deployment/catalog-operator rollout to complete
INFO[0030]   Deployment "olm/catalog-operator" successfully rolled out
INFO[0030] Waiting for deployment/packageserver rollout to complete
INFO[0031]   Waiting for Deployment "olm/packageserver" to rollout: 0 of 2 updated replicas are available
INFO[0040]   Deployment "olm/packageserver" successfully rolled out
INFO[0041] Successfully installed OLM version "0.28.0"

NAME                                            NAMESPACE    KIND                        STATUS
catalogsources.operators.coreos.com                          CustomResourceDefinition    Installed
clusterserviceversions.operators.coreos.com                  CustomResourceDefinition    Installed
installplans.operators.coreos.com                            CustomResourceDefinition    Installed
olmconfigs.operators.coreos.com                              CustomResourceDefinition    Installed
operatorconditions.operators.coreos.com                      CustomResourceDefinition    Installed
operatorgroups.operators.coreos.com                          CustomResourceDefinition    Installed
operators.operators.coreos.com                               CustomResourceDefinition    Installed
subscriptions.operators.coreos.com                           CustomResourceDefinition    Installed
olm                                                          Namespace                   Installed
operators                                                    Namespace                   Installed
olm-operator-serviceaccount                     olm          ServiceAccount              Installed
system:controller:operator-lifecycle-manager                 ClusterRole                 Installed
olm-operator-binding-olm                                     ClusterRoleBinding          Installed
cluster                                                      OLMConfig                   Installed
olm-operator                                    olm          Deployment                  Installed
catalog-operator                                olm          Deployment                  Installed
aggregate-olm-edit                                           ClusterRole                 Installed
aggregate-olm-view                                           ClusterRole                 Installed
global-operators                                operators    OperatorGroup               Installed
olm-operators                                   olm          OperatorGroup               Installed
packageserver                                   olm          ClusterServiceVersion       Installed
operatorhubio-catalog                           olm          CatalogSource               Installed
```

## Uninstallation

Install [operator-sdk](https://sdk.operatorframework.io/docs/installation/) and
have a valid kubeconfig set to connect to the cluster, then:

```
% operator-sdk olm uninstall
```