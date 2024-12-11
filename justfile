deploy-nixos host:
    nixos-rebuild switch --use-remote-sudo --build-host {{host}} --target-host {{host}} --flake ".#{{host}}"