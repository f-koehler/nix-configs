{
  lib,
  isWorkstation,
  ...
}: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimdiffAlias = true;
    colorschemes.catppuccin.enable = true;
    globals.mapleader = " ";
    plugins = {
      copilot-cmp.enable = isWorkstation;
      copilot-lua = {
        suggestion.enabled = false;
        panel.enabled = false;
      };
      cmake-tools.enable = true;
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources =
            [
              {name = "nvim_lsp";}
              {name = "path";}
              {name = "buffer";}
              {name = "luasnip";}
            ]
            ++ (lib.optionals isWorkstation [
              {name = "copilot";}
            ]);
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };
        };
      };
      cmp-nvim-lsp.enable = true;
      gitsigns.enable = true;
      indent-blankline = {
        enable = true;
      };
      lsp = {
        enable = true;
        servers = {
          bashls.enable = isWorkstation;
          clangd.enable = isWorkstation;
          cmake.enable = isWorkstation;
          gopls.enable = isWorkstation;
          nil-ls.enable = true;
          pyright.enable = isWorkstation;
          rust-analyzer = {
            enable = isWorkstation;
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
      overseer.enable = true;
      rainbow-delimiters.enable = true;
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
      };
      trouble = {
        enable = true;
        settings = {
          auto_close = true;
          icons = true;
        };
      };
      web-devicons = {
        enable = true;
        settings.color_icons = true;
      };
    };
    opts = {
      number = true;
      tabstop = 4;
      softtabstop = -1;
      shiftwidth = 0;
      shiftround = true;
      expandtab = true;
      autoindent = true;
      cursorline = true;
    };
  };
}
