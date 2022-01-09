# Flux

```shell
flux install \
    --components source-controller,kustomize-controller,helm-controller \
    --toleration-keys node-role.kubernetes.io/master \
    --export \
    --version v0.24.1 \
    --watch-all-namespaces false \
    > flux.yaml
```
