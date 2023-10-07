#!/bin/bash
set -euf -o pipefail

nix flake update .

if [ "$(uname -s)" = "Darwin" ]; then
    NUM_JOBS="$(sysctl -n hw.ncpu)"
    nix run --max-jobs ${NUM_JOBS} nix-darwin -- switch --flake .
    brew upgrade
elif [ -f "/etc/NIXOS" ]; then
    echo "NixOS needs to be implemented"
    exit 1
else
    NUM_JOBS="$(nproc -a)"
    nix run --max-jobs ${NUM_JOBS} hume-manager/master -- switch -b backup --flake .
    flatpak update --user -y
    flatpak update --system -y
    pkcon refresh --plain -y
    pkcon update --plain -y
fi
