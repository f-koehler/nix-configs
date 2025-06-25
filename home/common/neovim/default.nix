{ config, ... }:
{
  imports = [
    ./plugins

    ./autocmd.nix
    ./filetypes.nix
    ./keymaps.nix
    ./options.nix
  ];

  programs.nixvim = {
    nixpkgs.config.allowUnfree = true;
    enable = true;
    defaultEditor = true;
    vimdiffAlias = true;
    globals.mapleader = " ";
    editorconfig.enable = true;
    clipboard.providers.wl-copy.enable = true;
  };
  stylix.targets.nixvim.enable = config.programs.nixvim.enable;
}
