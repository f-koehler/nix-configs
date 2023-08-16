#!/bin/bash
set -euf -o pipefail
nix-channel --update darwin
darwin-rebuild switch --flake ${HOME}/Code/configs/nix-darwin/
