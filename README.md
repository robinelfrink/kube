# My Kubernetes

My Kubernetes setup. Useless for you, but free to use.

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
  nfs-server: 10.1.1.2
  nfs-path: /nfs/export
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
