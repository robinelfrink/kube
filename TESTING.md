# Testing

## Chart linting

```shell
ct lint --check-version-increment=false --all
```

## Chart template tests

```shell
helm template test charts/cluster-issuers --debug
helm template test charts/helmrelease-wrapper --debug
```

## Chart unit tests

```shell
helm unittest --helm3 charts/cluster-issuers
helm unittest --helm3 charts/helmrelease-wrapper
```
