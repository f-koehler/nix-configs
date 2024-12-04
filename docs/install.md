```shell
HOST=<HOST> nix run github:nix-community/nixos-anywhere -- --build-on-remote --flake ".#$HOST" --generate-hardware-config nixos-generate-config ./nixos/hardware/$HOST.nix root@$HOST
```

```shell
HOST=<host> nixos-rebuild --build-host=fkoehler@${HOST} --target-host=fkoehler@${HOST} boot --flake "#.${HOST}
```
