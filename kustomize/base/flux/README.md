# Flux

```shell
flux install \
    --components=source-controller,kustomize-controller,helm-controller \
    --toleration-keys=node-role.kubernetes.io/master \
    --toleration-keys=node-role.kubernetes.io/control-plane \
    --version=v<version> \
    --namespace=kube-cluster \
    --watch-all-namespaces=false \
    --export \
    > flux.yaml
```
