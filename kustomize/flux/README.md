# Flux

```shell
flux --namespace kube-flux \
    install \
    --components source-controller,kustomize-controller,helm-controller \
    --network-policy false \
    --toleration-keys node-role.kubernetes.io/master \
    --export \
    --version v0.15.3 \
    > flux.yaml
```
