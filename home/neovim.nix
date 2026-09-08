{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.neovim
  ];
  programs.ripgrep.enable = true;
  programs.fd.enable = true;
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Code/nix-configs/home/neovim-config";
}
