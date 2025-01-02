{
  pkgs,
  nodeConfig,
  ...
}: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimdiffAlias = true;
    colorschemes.catppuccin.enable = true;
    globals.mapleader = " ";
    editorconfig.enable = true;
    clipboard.providers.wl-copy.enable = true;
    filetype = {
      filename = {
        "Snakefile" = "snakemake";
      };
    };
    plugins = {
      cmake-tools.enable = true;
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            {name = "nvim_lsp";}
            {name = "path";}
            {name = "buffer";}
            {name = "luasnip";}
          ];
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
      codeium-nvim = {
        enable = nodeConfig.isWorkstation;
      };
      gitsigns.enable = true;
      indent-blankline = {
        enable = true;
      };
      lsp = {
        enable = true;
        servers = {
          bashls.enable = nodeConfig.isWorkstation;
          clangd.enable = nodeConfig.isWorkstation;
          cmake.enable = nodeConfig.isWorkstation;
          gopls.enable = nodeConfig.isWorkstation;
          nil_ls.enable = true;
          pyright.enable = nodeConfig.isWorkstation;
          rust_analyzer = {
            enable = nodeConfig.isWorkstation;
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
      neotest = {
        enable = true;
        adapters = {
          python.enable = true;
          rust.enable = true;
        };
      };
      notify.enable = true;
      nvim-tree = {
        enable = true;
        autoClose = true;
        openOnSetup = false;
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
        };
      };
      web-devicons = {
        enable = true;
        settings.color_icons = true;
      };
      which-key = {
        enable = true;
        settings = {
          expand = 1;
          show_keys = true;
        };
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
    autoCmd = [
      {
        command = "lua vim.lsp.buf.format()";
        event = ["BufWritePre"];
      }
    ];
    keymaps = [
      {
        action = ":lua vim.lsp.buf.definition()<CR>";
        key = "gd";
        mode = "n";
        options = {
          silent = true;
          desc = "Go to definition.";
        };
      }
      {
        action = ":lua vim.lsp.buf.declaration()<CR>";
        key = "gD";
        mode = "n";
        options = {
          silent = true;
          desc = "Go to declaration.";
        };
      }
    ];
    performance = {
      byteCompileLua = {
        enable = true;
        initLua = true;
      };
      combinePlugins.enable = true;
    };
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "neotest-ctest";
        src = pkgs.fetchFromGitHub {
          owner = "orjangj";
          repo = "neotest-ctest";
          rev = "885b270f3398f61c8196d0ac0b45744a45507737";
          hash = "sha256-gtektgnJoVSwP8B18ZNF50PJKQ+R/FCC8NzjuPNM57Q=";
        };
      })
    ];
  };
}
