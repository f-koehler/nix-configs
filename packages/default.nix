{pkgs ? (import ./nixpkgs.nix) {}}: {
  timetagger = pkgs.callPackage ./timetagger {};
}
