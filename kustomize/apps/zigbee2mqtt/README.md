# zigbee2mqtt

## Source

* [Code](https://github.com/Koenkk/zigbee2mqtt)
* [Helm chart](https://github.com/k8s-at-home/charts/tree/master/charts/stable/zigbee2mqtt)

## Variables

| name       | required | default             | description
|------------|----------|---------------------|-------------
| host       | yes      |                     | Hostname for the Ingress
| issuer     | no       | letsencrypt-staging | The certificate issuer to use
| usbDevice  | no       | /dev/ttyUSB0        | Path to your zigbee device
| mqttServer | no       | `mqtt://localhost`  | MQTT server URL

## USB

`/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0`
