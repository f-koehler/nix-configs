# Use nixpkgs from current flake.lock when building packages
let
  nixpkgsLock = (builtins.fromJSON (builtins.readFile ../flake.lock)).nodes.nixpkgs.locked;
in
  import (fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/${nixpkgsLock.rev}.tar.gz";
    sha256 = nixpkgsLock.narHash;
  })
