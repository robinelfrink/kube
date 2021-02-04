# nfs-subdir-external-provisioner

## Source

* [Code](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner)
* [Helm chart](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner/tree/master/charts/nfs-subdir-external-provisioner)

## Variables

| name       | required | default       | description
|------------|----------|---------------|-------------
| server     | yes      |               | NFS server address or hostname
| path       | yes      |               | NFS export path
| accessMode | no       | ReadWriteMany | Storage class access mode
