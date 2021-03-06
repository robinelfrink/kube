# My Kubernetes

My personal production Kubernetes setup. This is probably useless for you,
but free to use anything you find here.

This is also a bit of a playground for related automation (such as
(GitHub actions)[https://github.com/features/actions].

Requirements: [flux](https://toolkit.fluxcd.io/).

## Create a `Namespace`

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: mykube
```

## Create a `Secret`

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: config
  namespace: mykube
stringData:
  admin-email: admin@example.com
  nfs: |
    enabled: true
    server: 10.1.1.2
    path: /nfs/export
  vaultwarden: |
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
  interval: 5m
  url: https://github.com/robinelfrink/kube
```

## Create a `Kustomization`

```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: kube
  namespace: mykube
spec:
  interval: 5m
  path: ./kustomize
  prune: true
  sourceRef:
    kind: GitRepository
    name: kube
  targetNamespace: mykube
  validation: client
```
