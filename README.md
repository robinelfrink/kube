# My Kubernetes

My personal production Kubernetes setup. This is probably useless for you,
but free to use anything you find here.

Based on [Talos Linux](https://www.talos.dev/) and
[https://fluxcd.io/](https://fluxcd.io/). A description of how I
deploy nodes and manifests can be found in [DEPLOY.md](DEPLOY.md), which
exists mostly for me in case I need to deploy from scratch.

Here's a graph of my current infrastructure:

```mermaid
architecture-beta
  group home(cloud)[Home]
  service mainserver(server)[Main server] in home
  service smallbox(server)[Small Box] in home
  service router(internet)[Router] in home
  service switch(internet)[Switch] in home
  service modem(internet)[Modem] in home
  modem:R -- L:router
  router:B -- T:switch
  router:B -- T:mainserver
  switch:B -- T:smallbox

  group cloud(cloud)[Cloud]
  service cloudserver(server)[Cloud Server] in cloud

  mainserver{group}:B -- T:cloudserver{group}
```
