```shell
nix run github:nix-community/nixos-anywhere -- --build-on-remote --flake .#<FLAKEREF> --generate-hardware-config nixos-facter facter.json root@<IP_ADRESS>
```
