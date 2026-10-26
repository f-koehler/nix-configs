{ pkgs, ... }: {
  imports = [
    ./cpp.nix
    ./go.nix
    ./latex.nix
    ./node.nix
    ./rust.nix
  ];
  environment.systemPackages = [
    pkgs.prek
  ];
}
