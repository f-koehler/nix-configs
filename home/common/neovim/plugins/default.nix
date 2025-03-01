_: {
  imports = [
    ./cmp.nix
    ./codeium.nix
    ./conform-nvim.nix
    ./lsp.nix
    ./lualine.nix
    ./neo-tree.nix
    ./neotest.nix
    ./telescope.nix
    ./treesitter.nix
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
      toggleterm.enable = true;
      trouble = {
        enable = true;
        settings = {
          auto_close = true;
        };
      };
      web-devicons = {
        enable = true;
        settings.color_icons = true;
      };
    };
    # extraPlugins = [
    #   (pkgs.vimUtils.buildVimPlugin {
    #     name = "neotest-ctest";
    #     src = pkgs.fetchFromGitHub {
    #       owner = "orjangj";
    #       repo = "neotest-ctest";
    #       rev = "885b270f3398f61c8196d0ac0b45744a45507737";
    #       hash = "sha256-gtektgnJoVSwP8B18ZNF50PJKQ+R/FCC8NzjuPNM57Q=";
    #     };
    #   })
    # ];
  };
}
