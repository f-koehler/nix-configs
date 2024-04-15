{pkgs ? (import ./nixpkgs.nix) {}}: {
  inshellisense = pkgs.callPackage ./inshellisense.nix {};
}
