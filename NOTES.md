## Watch packet drop events cluster-wide

```shell
$ kubectl get events --all-namespaces --field-selector reason=PacketDrop --watch
```

## Run Renovate locally

```shell
$ podman run --interactive --tty --rm \
      --volume $(pwd):/usr/src/app \
      --env LOG_LEVEL=debug \
      --env GIT_CONFIG_COUNT=1 \
      --env GIT_CONFIG_KEY_0=safe.directory \
      --env GIT_CONFIG_VALUE_0=/usr/src/app \
      docker://renovate/renovate:slim \
      --platform=local
```

## Run emergency pod with hostPath mount

```shell
$ export NODE=<nodename>
$ kubectl run emergency --image ubuntu \
      --namespace=kube-system \
      --overrides='{
          "spec": {
            "containers": [
              {
                "name": "emergency",
                "image": "ubuntu",
                "args": ["sh", "-c", "sleep infinity"],
                "volumeMounts": [
                  {"mountPath": "/host", "name": "hostdir"},
                  {"mountPath": "/dev", "name": "hostdev"}
                ],
                "securityContext": {"privileged": true}
              }
            ],
            "volumes": [
              {
                "name":"hostdir",
                "hostPath": {"path": "/", "type": "Directory"}
              },
              {
                "name":"hostdev",
                "hostPath": {"path": "/dev", "type": "Directory"}
              }
            ],
            "securityContext": {"capabilities": {"add": ["SYS_ADMIN"]}},
            "nodeSelector": {"kubernetes.io/hostname": "'${NODE}'"}
          }
        }'
$ kubectl exec --stdin --tty --namespace kube-system emergency -- bash
[...]
$ kubectl delete pod --namespace kube-system kube-system emergency
```
