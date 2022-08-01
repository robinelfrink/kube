# vaultwarden

## Source

* [Code](https://github.com/dani-garcia/vaultwarden)
* [Helm chart](https://github.com/k8s-at-home/charts/tree/master/charts/stable/vaultwarden)

## Variables

| name       | required | default             | description
|------------|----------|---------------------|-------------
| host       | yes      |                     | Hostname for the Ingress
| issuer     | no       | letsencrypt-staging | The certificate issuer to use
| admintoken | no       |                     | Admin token to enable /admin uri
