# TPEEG k9s image

This repository includes a `TPEEG` branded `k9s` build plus a helper script for running it against a `k3s` cluster.

## Build

```bash
docker buildx build \
  --platform linux/amd64 \
  --build-arg TARGETOS=linux \
  --build-arg TARGETARCH=amd64 \
  --build-arg GIT_REV=$(git rev-parse --short HEAD) \
  -t 10.166.249.129:5000/riseiot/amd64/k9s_test:1.2 \
  --load .
```

If your build host is already `amd64` Linux and your Docker installation supports regular multi-stage builds well, a plain `docker build` may also work. The `buildx` command above is the recommended path because it also works reliably from Apple Silicon or other non-`amd64` hosts.

## Run

`entrypoint.sh` runs `k9s --splashless -A` by default, so this is enough:

```bash
docker run --rm -it \
  --platform linux/amd64 \
  --network host \
  -v /etc/rancher/k3s/k3s.yaml:/root/.kube/config:ro \
  10.166.249.129:5000/riseiot/amd64/k9s_test:1.2
```

If you want the shortest host-side command, use:

```bash
chmod +x ./run-k9s-docker.sh
./run-k9s-docker.sh
```

The helper script already includes:

```bash
--platform linux/amd64
--network host
-v /etc/rancher/k3s/k3s.yaml:/root/.kube/config:ro
```

So you do not need to type those each time.

## Optional args

Passing arguments overrides the default `-A` startup:

```bash
./run-k9s-docker.sh -n kube-system
./run-k9s-docker.sh --readonly
```

## Build host requirements

On the machine that builds or runs this image, you typically only need:

1. Docker with `buildx` support
2. Access to the repository source code

You do not need `go` installed on the host because the Docker build handles compilation inside the container.

On the machine that runs the container against `k3s`, you also need:

1. Docker
2. Read access to `/etc/rancher/k3s/k3s.yaml`
3. Network access to the target `k3s` cluster
