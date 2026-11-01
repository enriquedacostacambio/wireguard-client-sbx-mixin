#!/bin/sh
set -e

TAG="${1:-$(git branch --show-current)}"

docker buildx build . \
    -f wireguard-client-sbx-mixin.yaml \
    -t docker.io/enriquedacostacambio/wireguard-client-sbx-mixin:${TAG} \
    --push
