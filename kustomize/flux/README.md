# Flux

```shell
flux --namespace kube-flux \
    install \
    --components source-controller,kustomize-controller,helm-controller \
    --toleration-keys node-role.kubernetes.io/master \
    --export \
    --version v0.17.2 \
    > flux.yaml
```
