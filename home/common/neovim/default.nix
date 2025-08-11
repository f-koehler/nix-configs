{ inputs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
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

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        integrations = {
          neotree = true;
          neotest = true;
          cmp = true;
          telescope.enabled = true;
          which_key = true;
        };
      };
    };
    plugins.lualine.settings.options.theme = "catppuccin";
  };
  stylix.targets.nixvim.enable = false;
}
