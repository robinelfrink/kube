# nextcloud

## Source

* [Code](https://github.com/nextcloud/server)
* [Helm chart](https://github.com/nextcloud/helm/tree/master/charts/nextcloud)

## Variables

| name     | required | default             | description
|----------|----------|---------------------|-------------
| host     | yes      |                     | Hostname for the Ingress
| issuer   | no       | letsencrypt-staging | The certificate issuer to use
| username | yes      |                     | Initial username
| password | yes      |                     | Initial password
