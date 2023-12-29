#!/bin/bash
set -euf -o pipefail

#nix flake update .

if [ "$(uname -s)" = "Darwin" ]; then
    NUM_JOBS="$(sysctl -n hw.ncpu)"
    nix run --max-jobs ${NUM_JOBS} nix-darwin -- switch --flake ".#mac_arm64"
    brew upgrade
elif [ -f "/etc/NIXOS" ]; then
    echo "NixOS needs to be implemented"
    exit 1
else
    NUM_JOBS="$(nproc --all)"
    nix run --max-jobs ${NUM_JOBS} home-manager/master -- switch -b backup --flake ".#linux_x64"
    cd plasma && nix-shell --run "ansible-galaxy install -r requirements.yml && ansible-playbook plasma.yml" -p ansible libsForQt5.kconfig && cd ..
    flatpak update --user -y
    flatpak update --system -y
    if [ -f /etc/redhat-release ]; then
	sudo dnf upgrade --refresh -y
    else
    	sudo pkcon refresh --plain -y
    	sudo pkcon update --plain -y
    fi
fi
