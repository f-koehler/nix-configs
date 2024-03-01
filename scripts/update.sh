#!/bin/bash
set -euf -o pipefail

#nix flake update .

if [ "$(uname -s)" = "Darwin" ]; then
	NUM_JOBS="$(sysctl -n hw.ncpu)"
	nix run --max-jobs "${NUM_JOBS}" nix-darwin -- switch --flake ".#mac_arm64"
	brew upgrade
elif [ -f "/etc/NIXOS" ]; then
	sudo nixos-rebuild switch --flake .
else
	NUM_JOBS="$(nproc --all)"
	nix run --max-jobs "${NUM_JOBS}" home-manager/master -- switch -b backup --flake ".#linux_x64"
	cd flatpak && nix-shell --run "ansible-galaxy install -r requirements.yml && ansible-playbook flatpak.yml" -p ansible && cd ..
	flatpak update --user -y
	flatpak update --system -y
	if [ -f /etc/redhat-release ]; then
		sudo dnf upgrade --refresh -y
	else
		sudo pkcon refresh --plain -y
		sudo pkcon update --plain -y
	fi
fi
