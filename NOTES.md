## Watch packet drop events cluster-wide

```shell
$ kubectl get events --all-namespaces --field-selector reason=PacketDrop --watch
```
