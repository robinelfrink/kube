# Flux

## Source

* [Code](https://github.com/fluxcd/flux2)

```shell
flux install \
    --components=source-controller,kustomize-controller,helm-controller \
    --toleration-keys=node-role.kubernetes.io/master \
    --toleration-keys=node-role.kubernetes.io/control-plane \
    --version=v0.37.0 \
    --namespace=kube-cluster \
    --watch-all-namespaces=false \
    --export \
    > flux.yaml
```
