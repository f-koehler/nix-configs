build:
    nixos-rebuild build --flake ".#homeserver2"
deploy:
    nixos-anywhere --generate-hardware-config nixos-facter ./os/hardware/homeserver2.json --flake ".#homeserver2" --target-host root@192.168.122.67
