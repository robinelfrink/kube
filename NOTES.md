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

## Run pods with hostPath mount

```shell
$ kubectl run busybox --image busybox \
      --stdin --tty --rm \
      --namespace=kube-system \
      --overrides='
        {
          "spec": {
            "containers": [
              {
                "name": "busybox",
                "image": "busybox",
                "stdin": true,
                "stdinOnce": true,
                "tty": true,
                "volumeMounts": [{
                  "mountPath": "/host",
                  "name": "hostdir"
                }]
              }
            ],
            "volumes": [{
              "name":"hostdir",
              "hostPath": {
                "path": "/",
                "type": "Directory"
              }
            }],
            "nodeSelector": {
              "kubernetes.io/hostname": "<nodename>"
            }
          }
        }
        '
```
