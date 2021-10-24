# My Kubernetes

My personal production Kubernetes setup. This is probably useless for you,
but free to use anything you find here.

This is also a bit of a playground for related automation (such as
[GitHub actions](https://github.com/features/actions)).

Requirements: The
[Flux CLI](https://fluxcd.io/docs/installation/#install-the-flux-cli)
binary.

## Bootstrap Flux

```shell
flux install \
    --namespace mykube \
    --components source-controller,kustomize-controller,helm-controller \
    --toleration-keys node-role.kubernetes.io/master \
    --watch-all-namespaces false
```

## Create a `Secret`

Note the double `namespace:`.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: config
  namespace: mykube
stringData:
  namespace: mykube
  branch: main
  adminEmail: admin@example.com
  config: |
    nfs:
      enabled: true
      server: 10.1.1.2
      path: /nfs/export
    vaultwarden:
      - name: vaultwarden
        namespace: vaultwarden
        host: https://vaultwarden.example.com
        issuer: letsencrypt-staging
```

## Create a `GitRepository`

```yaml
apiVersion: source.toolkit.fluxcd.io/v1beta1
kind: GitRepository
metadata:
  name: kube
  namespace: mykube
spec:
  interval: 1h
  url: https://github.com/robinelfrink/kube
```

## Apply

```shell
kubectl apply --namespace mykube \
    --kustomize https://github.com/robinelfrink/kube/kustomize?ref=main
```
