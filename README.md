# wireguard-client-sbx-mixin

Docker Sandbox WireGuard client mixin (wireguard-go; userspace)

## Example

```sh
sbx run shell \
	--kit docker.io/enriquedacostacambio/wireguard-client-sbx-mixin:0.0.1
```

Or if you want to autoconnect to on startup:
```sh
sbx run shell \
	--kit docker.io/enriquedacostacambio/wireguard-client-sbx-mixin:0.0.1 \
	--kit-arg "wireguard_client_mode=auto"
	--kit-arg "wireguard_client_config=$(cat w0.conf)"
```
Where
- `wireguard_client_config` is the wg-quick client configuration.

## Build

```sh
./build.sh x.y.z
```

To publsh:
```sh
./build.sh x.y.z --push
```
