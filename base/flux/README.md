# Flux

* [Code](https://github.com/fluxcd/flux2)

## Upgrade instruction

```shell
flux install \
    --components=source-controller,kustomize-controller,helm-controller \
    --toleration-keys=node-role.kubernetes.io/control-plane \
    --namespace=flux \
    --export \
    > flux.yaml
```
