# wireguard-client-sbx-mixin

Docker Sandbox WireGuard client mixin (wireguard-go; userspace)

## Example

```sh
sbx run shell --kit "git+https://github.com/enriquedacostacambio/wireguard-client-sbx-mixin.git#ref=v0.0.1" --kit-arg "wireguard_client_config=$(cat w0.conf)"
```
