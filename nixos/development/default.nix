{ pkgs, ... }: {
  imports = [
    ./cpp.nix
    ./go.nix
    ./latex.nix
    ./node.nix
    ./python.nix
    ./rust.nix
  ];
  environment.systemPackages = [
    pkgs.prek
  ];
}
