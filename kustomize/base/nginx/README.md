# ingress-nginx

## Source

* [Code](https://github.com/kubernetes/ingress-nginx)
* [Helm chart](https://github.com/kubernetes/ingress-nginx/tree/master/charts/ingress-nginx)

## Variables

| name          | required | default | description
|---------------|----------|---------|-------------
| httpNodePort  | no       | 30080   | HTTP nodePort to listen on
| httpsNodePort | no       | 30443   | HTTPS nodePort to listen on
