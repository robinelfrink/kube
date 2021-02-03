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
  admin-email: admin@example.com
  nfs: |
    enables: true
    values:
      nfs:
        server: 10.1.1.2
        path: /nfs/export
  bitwarden: |
    - name: bitwarden
      namespace: bitwarden
      values:
        bitwarden:
          signups_allowed: false
          server_admin_email: admin@example.com
          domain: https://bitwarden.example.com
        ingress:
          annotations:
            kubernetes.io/ingress.class: nginx
            cert-manager.io/cluster-issuer: letsencrypt-staging
          paths:
            - '/'
          hosts:
            - bitwarden.example.com
          tls:
            - hosts:
                - bitwarden.example.com
              secretName: bitwarden-tls-secret
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
