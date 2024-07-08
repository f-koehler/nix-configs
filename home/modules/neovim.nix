_: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimdiffAlias = true;
    colorschemes.catppuccin.enable = true;
    plugins = {
      cmp.enable = true;
      cmp-nvim-lsp.enable = true;
      gitsigns.enable = true;
      lsp.enable = true;
      lualine = {
        enable = true;
        globalstatus = true;
        iconsEnabled = true;
      };
      notify.enable = true;
      nvim-tree = {
        enable = true;
        autoClose = true;
        hijackCursor = true;
      };
      telescope = {
        enable = true;
        keymaps = {
          "<C-p>" = {
            action = "git_files";
            options.desc = "Telescope Git Files";
          };
        };
      };
      todo-comments.enable = true;
      treesitter = {
        enable = true;
        indent = true;
      };
      trouble = {
        enable = true;
        settings = {
          auto_close = true;
          icons = true;
        };
      };
    };
    opts = {
      number = true;
    };
  };
}
