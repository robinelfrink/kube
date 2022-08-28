# cilium

## Source

* [Code](https://github.com/cilium/cilium/)
* [Helm chart](https://github.com/cilium/cilium/tree/v1.12.1/install/kubernetes/cilium)

## Variables

| name       | required | default | description
|------------|----------|---------|-------------
| enabled    | no       | false   | Whether to install Cilium
| apiAddress | yes      |         | API server address
| apiPort    | no       | 6443    | API server port
