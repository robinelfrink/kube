# Flux

```shell
flux --namespace kube-flux \
    install \
    --components source-controller,kustomize-controller,helm-controller \
    --network-policy false \
    --toleration-keys node-role.kubernetes.io/master \
    --export \
    --version v0.16.2 \
    > flux.yaml
```
