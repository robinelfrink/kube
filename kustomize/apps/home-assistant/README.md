# home-assistant

## Source

* [Code](https://github.com/home-assistant/core)
* [Helm chart](https://github.com/k8s-at-home/charts/tree/master/charts/stable/home-assistant)

## Variables

| name        | required | default             | description
|-------------|----------|---------------------|-------------
| host        | yes      |                     | Hostname for the Ingress
| issuer      | no       | letsencrypt-staging | The certificate issuer to use
| timezone    | no       | Europe/Amsterdam    | The timezone of the installation
| hostNetwork | no       | false               | Enable devices to be discoverable
| privileged  | no       | false               | Enable passing thru a USB device
