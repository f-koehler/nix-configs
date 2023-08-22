#!/bin/bash
nix-shell --run "nixpkgs-fmt --check **/*.nix" -p nixpkgs-fmt