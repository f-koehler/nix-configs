_: {
  imports = [
    ./cmp.nix
    ./conform-nvim.nix
    ./lsp.nix
    ./lualine.nix
    ./neo-tree.nix
    ./neotest.nix
    ./telescope.nix
    ./treesitter.nix
    ./trouble.nix
    ./which-key.nix
  ];

  programs.nixvim = {
    plugins = {
      cmake-tools.enable = true;
      gitsigns.enable = true;
      indent-blankline = {
        enable = true;
      };
      luasnip.enable = true;
      notify.enable = true;
      overseer.enable = true;
      rainbow-delimiters.enable = true;
      todo-comments.enable = true;
      web-devicons = {
        enable = true;
        settings.color_icons = true;
      };
    };
  };
}
