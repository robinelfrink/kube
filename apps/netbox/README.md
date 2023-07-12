# netbox

* [Code](https://github.com/netbox-community/netbox)
* [Helm chart](https://github.com/bootc/netbox-chart)

## using authintik

See [authentik documentation](https://goauthentik.io/integrations/services/netbox/).

Scope mapping confgiured in authentik:

```python
result = {'groups': [group.name for group in request.user.ak_groups.all()]}
if '<my authentik group>' in result['groups']:
  result['groups'].append('staff')
if '<my authentik admin group>' in result['groups']:
  result['groups'].append('superusers')
return result
```
