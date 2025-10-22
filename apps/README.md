# o5command/apps

This is the repository for "end-user" apps that are deployed on the Kubernetes cluster. They are what provide the cluster's value to SCP Wiki staff. They exist within subfolders and may be a full-blown app within the monorepo, built and deployed via GitHub Actions or ArgoCD, or they may be a simple [Helm Chart](https://helm.sh) that is deployed and configured once launched.

README files below this level should include both information on deployment and uninstallation as well as relevant information about the application itself.