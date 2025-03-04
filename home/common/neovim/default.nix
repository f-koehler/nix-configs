_: {
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
    colorschemes.catppuccin.enable = true;
    globals.mapleader = " ";
    editorconfig.enable = true;
    clipboard.providers.wl-copy.enable = true;
  };
}
