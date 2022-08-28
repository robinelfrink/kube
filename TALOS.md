# Talos

How I create a Talos node to put all my Kubernetes stuff on.

# Deploy a Talos node

Use the current favourite deployment method to install
[a recent version of Talos](https://github.com/siderolabs/talos/releases).

Wait for the machine to boot and note the assigned IP address.

## Generate machineconfig and talosconfig

Make sure to change the endpoint address and additional-sans below.

```shell
$ talosctl gen config mykube https://192.168.1.10:6443 \
      --additional-sans mykube.local \
      --config-patch-control-plane=@<(curl --silent --location https://github.com/robinelfrink/kube/raw/main/talos/controlplane.patch) \
      --with-docs=false \
      --with-examples=false
generating PKI and tokens
created controlplane.yaml
created worker.yaml
created talosconfig
```

## Create patch-file for the node

```shell
$ cat patch.json
[
  {
    "op": "replace",
    "path": "/machine/network/hostname",
    "value": "mykube1"
  },
  {
    "op": "replace",
    "path": "/machine/network/interfaces",
    "value": [
      {
        "interface": "eth0",
        "addresses": [
          "192.168.1.10/24"
        ],
        "routes": [
          {
            "network": "0.0.0.0/0",
            "gateway": "192.168.1.1"
          }
        ]
      }
    ]
  },
  {
    "op": "replace",
    "path": "/machine/network/nameservers",
    "value": [
      "8.8.8.8",
      "8.8.4.4"
    ]
  }
]
```

Apply the patch. Again use the IP address found earlier.

Change `controlplane.yaml` to `worker.yaml` if adding a worker node.

```shell
$ talosctl apply-config \
      --insecure \
      --endpoints=192.168.1.116 \
      --nodes=192.168.1.116 \
      --config-patch=@patch.json \
      --file=controlplane.yaml
```

## Merge and modify generated talosconfig

```shell
$ talosctl config merge talosconfig
$ talosctl --context mykube config endpoint 192.168.1.10
$ talosctl --context mykube config node 192.168.1.10
```

## Bootstrap etcd

Wait for Talos to finish installation first, and then:

```shell
$ talosctl --context mykube bootstrap
```

## Fetch kubeconfig

```shell
$ talosctl --context mykube kubeconfig ${KUBECONFIG}
```

## Install Cilium

```shell
$ helm repo add cilium https://helm.cilium.io/
$ helm install \
      --namespace kube-cilium \
      --create-namespace \
      --version 1.12.1 \
      --set ipam.mode=kubernetes \
      --set k8sServiceHost=192.168.1.10 \
      --set k8sServicePort=6443 \
      --set operator.replicas=1 \
      --set securityContext.privileged=true \
      cilium cilium/cilium
$ kubectl label namespace kube-cilium \
      pod-security.kubernetes.io/enforce=privileged
```

## Save and cleanup

Make sure to store `talosconfig`, `controlplane.yaml` and `worker.yaml` in a
safe place.

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
