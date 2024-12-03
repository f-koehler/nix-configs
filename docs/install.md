```shell
FLAKEREF=<flakeref> nix run github:nix-community/nixos-anywhere -- --build-on-remote --flake ".#$FLAKEREF" --generate-hardware-config nixos-facter nixos/$FLAKEREF/facter.json root@<HOST>
```
