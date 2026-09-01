## Watch packet drop events cluster-wide

```shell
$ kubectl get events --all-namespaces --field-selector reason=PacketDrop --watch
```

## Run Renovate locally

```shell
$ docker run --interactive --tty --rm \
      --volume $(pwd):/usr/src/app \
      --env LOG_LEVEL=debug \
      --env GIT_CONFIG_COUNT=1 \
      --env GIT_CONFIG_KEY_0=safe.directory \
      --env GIT_CONFIG_VALUE_0=/usr/src/app \
      ghcr.io/renovatebot/renovate \
      --platform=local
```

## Run emergency pod with hostPath mount

```shell
$ debug-pod [-n <nodename]
```
