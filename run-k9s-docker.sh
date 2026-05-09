#!/bin/sh
set -eu

IMAGE="${IMAGE:-10.166.249.129:5000/riseiot/amd64/k9s_test:1.4}"
KUBECONFIG_PATH="${KUBECONFIG_PATH:-/etc/rancher/k3s/k3s.yaml}"
PLATFORM="${PLATFORM:-linux/amd64}"

exec docker run --rm -it \
  --platform "${PLATFORM}" \
  --network host \
  -v "${KUBECONFIG_PATH}:/root/.kube/config:ro" \
  "${IMAGE}" \
  "$@"
