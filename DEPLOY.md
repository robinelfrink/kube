# Deploy a new cluster

My cluster runs on [Talos Linux](https://www.talos.dev/). Secrets are encrypted
using [SOPS](https://github.com/getsops/sops) and decrypted as needed by
[Flux](https://fluxcd.io/).

## Talos

### Generate configuration

This needs to be done only once. Configuration based on one control-plane node. The patches ensure that:

*  No CNI is installed.
*  No `kube-proxy` is installed.
*  Talos installs on disk `/dev/vda`.

```shell
$ export CLUSTER_NAME=mykube
$ export CLUSTER_ENDPOINT=192.168.1.5
$ export CLUSTER_SANS=mykube.local
$ talosctl gen config ${CLUSTER_NAME} https://${CLUSTER_ENDPOINT}:6443 \
      --additional-sans ${CLUSTER_SANS} \
      --config-patch-control-plane=@talos/controlplane-config.patch \
      --config-patch-worker=@talos/worker-config.patch \
      --with-docs=false \
      --with-examples=false \
      --output-dir=talos
generating PKI and tokens
created controlplane.yaml
created worker.yaml
created talosconfig
$ mv talosconfig ${TALOSCONFIG}
$ talosctl config endpoint ${CLUSTER_ENDPOINT}
```

Keep the generated files in a secure place.

### Deploy node

Use your favourite deployment method to install
[a recent version of Talos](https://github.com/siderolabs/talos/releases).

Wait for the machine to boot and note it's current IP address on the console.
Save it into `NODE_IP`:

```shell
$ export NODE_IP=192.168.1.54
```

#### Control-plane

```shell
$ export NODE_ADDRESS=192.168.1.10
$ export NODE_MASK=24
$ export NODE_HOSTNAME=cp1
$ export NODE_GATEWAY=192.168.1.1
$ export NODE_NAMESERVERS='["10.96.0.10","8.8.8.8","8.8.4.4"]'
$ talosctl apply-config \
      --insecure \
      --endpoints=${NODE_IP} \
      --nodes=${NODE_IP} \
      --config-patch=@<(cat talos/controlplane-node.patch | envsubst) \
      --file=talos/controlplane.yaml
```

If this is the first control-plane node, bootstrap etcd and fetch kubeconfig:

```shell
$ talosctl bootstrap \
      --nodes ${NODE_ADDRESS} \
      --endpoints ${NODE_ADDRESS}
[...]
$ talosctl kubeconfig \
      --nodes ${NODE_ADDRESS} \
      --endpoints ${NODE_ADDRESS} \
      ${KUBECONFIG}
```

#### Worker

```shell
$ export NODE_ADDRESS=192.168.1.15
$ export NODE_MASK=24
$ export NODE_HOSTNAME=worker1
$ export NODE_GATEWAY=192.168.1.1
$ export NODE_NAMESERVERS='["10.96.0.10","8.8.8.8","8.8.4.4"]'
$ talosctl apply-config \
      --insecure \
      --endpoints=${NODE_IP} \
      --nodes=${NODE_IP} \
      --config-patch=@<(cat talos/worker-node.patch | envsubst) \
      --file=talos/worker.yaml
```

### Add nodes to talosconfig

```shell
$ talosctl config node <ip addresses of all nodes, separated by space>
```

### Bootstrap Cilium and Flux

```shell
$ kubectl kustomize \
      --enable-helm \
      --load-restrictor=LoadRestrictionsNone \
      bootstrap | \
  kubectl apply --filename -
```

## SOPS

For convenience, store your cluster's name in a variable:

```shell
$ export CLUSTER_NAME=mykube
```

### Generate a SOPS secret

This needs to be done only once.

* Generate a gpg keypair:

```shell
$ gpg --batch --full-generate-key <<EOF
%no-protection
Key-Type: 1
Key-Length: 4096
Subkey-Type: 1
Subkey-Length: 4096
Expire-Date: 0
Name-Comment: Content ${CLUSTER_NAME}
Name-Real: ${CLUSTER_NAME}
EOF
```

* Export the private and public keys and store them somewhere safe.

```shell
$ gpg --export-secret-keys --armor \
      ${CLUSTER_NAME} > clusters/${CLUSTER_NAME}/gpg.sec
$ gpg --export --armor \
      ${CLUSTER_NAME} > clusters/${CLUSTER_NAME}/gpg.pub
```

* Create a kubernetes secret from the sops secret:

```shell
$ kubectl create secret generic sops-gpg \
      --namespace=flux \
      --from-file=sops.asc=<(gpg \
          --export-secret-keys \
          --armor ${CLUSTER_NAME})
```

### Create `GitRepository` and `Kustomization`

```shell
$ flux create source git kube \
      --namespace flux \
      --interval 30m \
      --url https://github.com/robinelfrink/kube \
      --branch main
$ flux create kustomization cluster \
      --namespace flux \
      --interval 30m \
      --decryption-provider sops \
      --decryption-secret sops-gpg \
      --source GitRepository/kube \
      --path ./cluster \
      --prune false
```

## Upgrade

### Upgrade Talos

```shell
$ talosctl upgrade --preserve
```

Optionally build a custom installer image at https://factory.talos.dev/, and
use that to upgrade Talos:

```shell
$ talosctl upgrade --preserve --image factory.talos.dev/installer/<generated hash>:v<version>
```

### Upgrade Kubernetes

```shell
$ talosctl upgrade-k8s --nodes ${NODE_ADDRESS}
```
