# Talos

How I create a Talos node to put all my Kubernetes stuff on.

# Deploy a Talos node

Use the current favourite deployment method to install
[a recent version of Talos](https://github.com/talos-systems/talos/releases).

Wait for the machine to boot and note the assigned IP address.

## Create patch-file

```shell
$ cat patch.json
[
  {
    "op": "replace",
    "path": "/machine/network",
    "value": {
      "hostname": "mykube",
      "interfaces": [
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
      ],
      "dhcp": false,
      "nameservers": [
        "8.8.8.8",
        "8.8.4.4"
      ]
    }
  },
  {
    "op": "replace",
    "path": "/machine/install/disk",
    "value": "/dev/vda"
  },
  {
    "op": "replace",
    "path": "/cluster/extraManifests",
    "value": [
      "https://raw.githubusercontent.com/robinelfrink/kube/main/kustomize/flux/flux.yaml"
    ]
  }
]
```

## Generate machineconfig and talosconfig

```shell
$ talosctl gen config mykube https://192.168.1.10:6443 \
      --config-patch="$(cat patch.json | tr -d '\n')" \
      --kubernetes-version=1.22.3 \
      --with-docs=false \
      --with-examples=false
generating PKI and tokens
created controlplane.yaml
created worker.yaml
created talosconfig
```

## Apply the configuration

Use the IP address found earlier.

```shell
$ talosctl apply-config \
      --insecure \
      --nodes=192.168.1.116 \
      --file=controlplane.yaml
```

## Merge and modify generated talosconfig

```shell
$ talosctl config merge talosconfig
$ talosctl config endpoint 192.168.1.10
$ talosctl config node 192.168.1.10
```

## Bootstrap the cluster

Wait for Talos to finish installation first, and then:

```shell
$ talosctl bootstrap --context mykube
```

## Fetch kubeconfig

```shell
$ talosctl kubeconfig ${KUBECONFIG}
```

## Save and cleanup

Make sure to store `talosconfig` and controlplane.yaml` in a safe place.

# Upgrade

To upgrade Talos:

```shell
talosctl upgrade \
    --preserve \
    --image ghcr.io/talos-systems/installer:v<new-version>
```

To upgrade Kubernetes:
```shell
talosctl upgrade-k8s \
    --from <current-version> \
    --to <new-version>
```

To upgrade Kubelet:
```shell
talosctl patch machineconfig --patch '
[{
  "op": "replace",
  "path": "/machine/kubelet/image",
  "value": "ghcr.io/talos-systems/kubelet:v<new-version>"
}]'
```
