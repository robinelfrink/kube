## Post installation

```shell
kubectl exec --stdin --tty --namespace gitea <gitea pod> -- \
    gitea admin auth update-oauth --id 1 \
    --group-claim-name gitea --admin-group admin --required-claim-name gitea
```
