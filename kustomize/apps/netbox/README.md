# netbox

## Source

* [Code](https://github.com/netbox-community/netbox)
* [Helm chart](https://github.com/bootc/netbox-chart)

## Variables

| name     | required | default             | description
|----------|----------|---------------------|-------------
| host     | yes      |                     | Hostname for the Ingress
| issuer   | no       | letsencrypt-staging | The certificate issuer to use
| password | yes      |                     | Admin user password
| apitoken | yes      |                     | Admin 40 character hex api token
