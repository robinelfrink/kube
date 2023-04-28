# Adding a cluster

For convenience, store your cluster's name in a variable:

```shell
$ export CLUSTER=<my cluster>
```

## Generate a SOPS secret

```

-  Generate a gpg keypair:

   ```shell
   $ gpg --batch --full-generate-key <<EOF
   %no-protection
   Key-Type: 1
   Key-Length: 4096
   Subkey-Type: 1
   Subkey-Length: 4096
   Expire-Date: 0
   Name-Comment: Content ${CLUSTER}
   Name-Real: ${CLUSTER}
   EOF
   ```

-  Retrieve the keypair and remember the fingerprint:

   ```shell
   $ gpg --list-secret-keys ${CLUSTER}
   sec   rsa4096 2023-01-09 [SCEA]
         254B2D0390AD463CB08D835353861260CE1E8F2C
   uid           [ultimate] <my cluster> (Content <my cluster>)
   ssb   rsa4096 2023-01-09 [SEA]
   $ export FINGERPRINT=254B2D0390AD463CB08D835353861260CE1E8F2C
   ```

-  Export the private and public keys and store them somewhere safe.

   ```shell
   $ gpg --export-secret-keys --armor ${CLUSTER} > clusters/${CLUSTER}/gpg.sec
   $ gpg --export --armor ${CLUSTER} > clusters/$CLUSTER/gpg.pub
   ```

-  Create a kubernetes secret holding cluster information and the sops secret:

   ```shell
   $ kubectl create namespace flux
   $ kubectl create secret generic cluster-info \
         --namespace=flux \
	 --from-literal=admin.email=my.email@domain \
	 --from-literal=api.address=192.168.1.5 \
	 --from-literal=nfs.server=192.168.1.1 \
	 --from-literal=nfs.path=/nfs/share \
	 --from-literal=cluster.issuer=letsencrypt \
	 --from-literal=vaultwarden.hostname=vaultwarden.example.com \
         --from-file=sops.asc=<(gpg \
             --export-secret-keys --armor ${CLUSTER})
   ```

-  Bootstrap the cluster

   ```shell
   $ kubectl apply --kustomize bootstrap
   ```
