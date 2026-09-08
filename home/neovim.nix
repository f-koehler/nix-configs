{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.luaPackages.luarocks
    pkgs.julia
    pkgs.neovim
    pkgs.kdePackages.qtdeclarative # for qmlformat
    pkgs.rustfmt
    pkgs.luaPackages.tree-sitter-cli
  ];
  programs.ripgrep.enable = true;
  programs.fd.enable = true;
  programs.npm.enable = true;
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Code/nix-configs/home/neovim-config";
}
