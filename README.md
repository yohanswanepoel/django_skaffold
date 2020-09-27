# Project to Skaffold a Django Application
This is for local innerloop development. You may want to extend it. I also tried asure draft - but that generated deprecated yaml and had some other odd behaviour, so Skaffold it is.

Essentially this allows me to run up the application pattern and have skaffold rebuild/redploy containers as I make code changes allowing high fidelity testing.

## Good bits
- Multi stage python build - saves a small amount of storage. This will safe heaps if you have to build packages from source
- Non-root container++

## Setup steps
- Minikube (addons registry-creds, ingress, storage-provisioner, default-storageclass)
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
minikube addons enable ingress
minikube ssh
docker login registry.redhat.io
copy file : sudo scp ~/.docker/config.json /var/lib/kubelet/config.json 

```
restart minikube, you should now be able asto pull from your secure registry.

## For local SQL Lite and hot reload - Make migrations wont run in this mode. Note File requires TAR for this to work
```bash
# Does not run migrations or reinstall requirements
skaffold dev -p hot_reload

```

## For local SQL Lite Then it is as simple as
```bash
skaffold dev

```

## For local PostgreSQL
This option deploys a postgresql container to run the database
```bash
skaffold dev -p with_pg

```

# For acess to web ui
This now uses the ingress so it requires a hosts entry 
```bash
# Get the up
minikube ip

# add to /etc/hosts 
[ip] django.info

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

roll deployment again
```bash
kubectl -n default rollout restart deployment skaffold-demo
```

## TODO
- Database migrations needs a better way (it is currently okay for Dev)
- Stateful set if need persistent storage
- Implement health probes
- Using hot reload, would it make sense to run make migrations and migrate as part of start script?
