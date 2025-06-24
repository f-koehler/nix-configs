{ pkgs, ... }:
{
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
    package = pkgs.nix;
  };
  home.packages = [
    pkgs.devenv
    pkgs.nil
    pkgs.nix-tree
    pkgs.nixfmt-rfc-style
  ];
  programs = {
    nh.enable = true;
  };
}
