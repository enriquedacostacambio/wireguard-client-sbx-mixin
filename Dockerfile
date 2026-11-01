ARG WIREGUARD_GO_VERSION
ARG TARGETARCH
ARG WIREGUARD_TOOLS_VERSION
ARG OPENRESOLV_VERSION
ARG ALPINE_VERSION
ARG GOLANG_VERSION

FROM golang:${GOLANG_VERSION} AS wireguard-go-build
WORKDIR /build
RUN apk add --no-cache git \
    && git clone https://github.com/WireGuard/wireguard-go.git . \
    && git checkout ${WIREGUARD_GO_VERSION} \
    && mkdir -p /build/output/ \
    && CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build \
       -ldflags="-s -w" \
       -o /build/output .

FROM alpine:${ALPINE_VERSION} AS wireguard-tools-build
WORKDIR /build
RUN apk add --no-cache \
        git \
        make \
        gcc \
        musl-dev \
        libmnl-dev \
        libmnl-static \
    && git clone https://github.com/wireguard/wireguard-tools.git . \
    && git checkout ${WIREGUARD_TOOLS_VERSION} \
    && make -C src LDFLAGS="-static" \
    && chmod +x /build/src/wg-quick/linux.bash

FROM alpine:${ALPINE_VERSION} AS openresolv-build
WORKDIR /build
RUN apk add --no-cache git make \
    && git clone https://github.com/NetworkConfiguration/openresolv.git . \
    && git checkout ${OPENRESOLV_VERSION} \
    && ./configure \
    && make DESTDIR=/output install \
    && chmod +x /build/resolvconf

FROM scratch
COPY --from=wireguard-go-build /build/output/wireguard /usr/bin/wireguard
COPY --from=wireguard-tools-build /build/src/wg /usr/bin/wg
COPY --from=wireguard-tools-build /build/src/wg-quick/linux.bash /usr/bin/wg-quick
COPY --from=openresolv-build /output /
COPY wireguard-go-setup.sh /usr/bin/wireguard-client-setup.sh
