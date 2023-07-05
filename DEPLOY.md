# Install Talos

How I deploy Talos nodes to put all my Kubernetes stuff on.

## Generate configuration

This needs to be done only once. The patches ensure that:

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
      --with-examples=false
generating PKI and tokens
created controlplane.yaml
created worker.yaml
created talosconfig
$ mv talosconfig ${TALOSCONFIG}
$ talosctl config endpoint ${CLUSTER_ENDPOINT}
```

Keep the generated files in a secure place.

## Deploy node

Use your favourite deployment method to install
[a recent version of Talos](https://github.com/siderolabs/talos/releases).

Wait for the machine to boot and note it's current IP address on the console.

Set variables needed for deployment

```shell
$ export NODE_IP=192.168.1.116
```

### Control-plane

```shell
$ export NODE_ADDRESS=192.168.1.10
$ export NODE_MASK=24
$ export NODE_HOSTNAME=cp1
$ export NODE_VIP=192.168.1.5
$ export NODE_GATEWAY=192.168.1.1
$ export NODE_NAMESERVERS='["10.96.0.10","8.8.8.8","8.8.4.4"]'
$ talosctl apply-config \
      --insecure \
      --endpoints=${NODE_IP} \
      --nodes=${NODE_IP} \
      --config-patch=@<(cat talos/controlplane-node.patch | envsubst) \
      --file=controlplane.yaml
```

If this is the first control-plane node, bootstrap etcd and fetch kubeconfig:

```shell
$ talosctl --nodes ${NODE_ADDRESS} --endpoints ${NODE_ADDRESS} bootstrap
[...]
$ talosctl --nodes ${NODE_ADDRESS} kubeconfig ${KUBECONFIG}
```

### Worker

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
      --file=worker.yaml
```

## Add nodes to talosconfig

```shell
$ talosctl config node <all nodes, separated by space>
```

## Install the Cilium Helm chart

```shell
$ kubectl create namespace cilium
$ kubectl label namespace cilium pod-security.kubernetes.io/enforce=privileged
$ helm repo add cilium https://helm.cilium.io/
$ helm install \
      --namespace cilium \
      --version 1.13.4 \
      --set ipam.mode=kubernetes \
      --set k8sServiceHost=${CLUSTER_ENDPOINT} \
      --set k8sServicePort=6443 \
      --set operator.replicas=1 \
      --set securityContext.privileged=true \
      cilium cilium/cilium
```

# Upgrade

To upgrade Talos:

```shell
talosctl upgrade \
    --preserve \
    --image ghcr.io/siderolabs/installer:v<new-version>
```

To upgrade Kubernetes:
```shell
talosctl upgrade-k8s \
    --from <current-version> \
    --to <new-version>
```
