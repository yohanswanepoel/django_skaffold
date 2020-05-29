# Project to Skaffold a Django Application
This is for local innerloop development. You may want to extend it. I also tried asure draft - but that generated deprecated yaml and had some other odd behaviour, so Skaffold it is.

Essentially this allows me to run up the application pattern and have skaffold rebuild/redploy containers as I make code changes allowing high fidelity testing.

## Setup steps
- Minikube (addons secure registry, ingress)
- Skaffold setup (https://skaffold.dev)
- I use Red Hat base images so setup registry info below
- Build is on Minikube

## Bits that make it work
- Buildfile to create container image - pretty standard
- k8sconfig folder and files that create the bits required
- skaffold.yaml that specifies the local CI/CD pipeline

## Setup registry (optional)
If you use a secure registry for base images you need this.
```bash
minikube ssh
docker login registry.redhat.io
copy file : sudo scp ~/.docker/config.json /var/lib/kubelet/config.json 

```
restart minikubbe, you should now be able to pull from your secure registry.

## Then it is as simple as
```bash
skaffold dev

minikube service skaffold-demo
```

## Useful for debugging
```bash
kubectl get pod <pod name> --output=yaml
```

Podman or buildah builds similar to this
```bash
podman build -t django:latest .

podman run -p 8000:8000 localhost/django:latest
```

## TODO
- Currently this is a single django app with local SQL DB
- Need to build out with Postgresql
- Build file needs tuning for multi-stage builds
