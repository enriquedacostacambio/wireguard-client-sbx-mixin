#!/bin/sh
set -e

TAG="${1:-$(git describe --exact-match --tags)}"

docker buildx build . \
    -f wireguard-client-sbx-mixin.yaml \
    -t docker.io/enriquedacostacambio/wireguard-client-sbx-mixin:${TAG} \
    --push
