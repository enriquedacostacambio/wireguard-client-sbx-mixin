FROM golang:1.27.3-alpine3.24 AS wireguard-go-build
ARG TARGETARCH
WORKDIR /build
RUN apk add --no-cache git \
    && git clone https://github.com/WireGuard/wireguard-go.git . \
    && git checkout 0.0.20250522 \
    && mkdir -p /build/output/ \
    && CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build \
       -ldflags="-s -w" \
       -o /build/output .

FROM alpine:3.24.3 AS wireguard-tools-build
WORKDIR /build
RUN apk add --no-cache \
        git \
        make \
        gcc \
        musl-dev \
        libmnl-dev \
        libmnl-static \
    && git clone https://github.com/wireguard/wireguard-tools.git . \
    && git checkout v1.0.20260223 \
    && make -C src LDFLAGS="-static" \
    && chmod +x /build/src/wg-quick/linux.bash

FROM scratch
COPY --from=wireguard-go-build /build/output/wireguard /usr/bin/wireguard
COPY --from=wireguard-tools-build /build/src/wg /usr/bin/wg
COPY --from=wireguard-tools-build /build/src/wg-quick/linux.bash /usr/bin/wg-quick
COPY install.sh /opt/wireguard-client-sbx-mixin/install.sh
