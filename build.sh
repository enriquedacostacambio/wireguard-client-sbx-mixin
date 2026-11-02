#!/bin/sh
set -e

TAG="${1}"
shift

docker buildx build ./src \
    -f ./src/wireguard-client-sbx-mixin.yaml \
    -t docker.io/enriquedacostacambio/wireguard-client-sbx-mixin:${TAG} \
    "$@"
