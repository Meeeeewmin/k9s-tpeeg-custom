# TPEEG k9s image

## Build

```bash
docker build -t 10.166.249.129:5000/riseiot/amd64/k9s_test:1.0.0 .
```

## Run

`entrypoint.sh` runs `k9s -A` by default, so this is enough:

```bash
docker run --rm -it \
  --platform linux/amd64 \
  --network host \
  -v /etc/rancher/k3s/k3s.yaml:/root/.kube/config:ro \
  10.166.249.129:5000/riseiot/amd64/k9s_test:1.0.0
```

If you want the shortest host-side command, use:

```bash
chmod +x ./run-k9s-docker.sh
./run-k9s-docker.sh
```

## Optional args

Passing arguments overrides the default `-A` startup:

```bash
./run-k9s-docker.sh -n kube-system
./run-k9s-docker.sh --readonly
```
