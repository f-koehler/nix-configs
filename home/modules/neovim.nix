_: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimdiffAlias = true;
    colorschemes.catppuccin.enable = true;
    globals.mapleader = " ";
    plugins = {
      copilot-cmp.enable = true;
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            {name = "nvim_lsp";}
            {name = "copilot";}
            {name = "path";}
            {name = "buffer";}
            {name = "luasnip";}
          ];
        };
      };
      cmp-nvim-lsp.enable = true;
      gitsigns.enable = true;
      lsp = {
        enable = true;
        servers = {
          bashls.enable = true;
          clangd.enable = true;
          cmake.enable = true;
          gopls.enable = true;
          nil-ls.enable = true;
          pyright.enable = true;
          rust-analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
        };
      };
      lualine = {
        enable = true;
        settings.options = {
          globalstatus = true;
          icons_enabled = true;
        };
      };
      luasnip.enable = true;
      notify.enable = true;
      nvim-tree = {
        enable = true;
        autoClose = true;
        openOnSetup = true;
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
        settings.indent.enable = true;
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
