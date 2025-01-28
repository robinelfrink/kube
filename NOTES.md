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
