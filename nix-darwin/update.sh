#!/bin/bash
set -euf -o pipefail
nix-channel --update
darwin-rebuild switch --flake ${HOME}/Code/configs/nix-darwin/

/opt/homebrew/bin/brew upgrade
