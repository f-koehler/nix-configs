{
  config,
  lib,
  pkgs,
  hasAnyTagOf,
  ...
}:
{
  options.fk.neovim.configDir = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/Code/nix-configs/home/neovim-config";
    description = "Checkout of the neovim config that ~/.config/nvim links to (out of store, so edits apply without a rebuild).";
  };

  config = {
    home.packages = [
      pkgs.luaPackages.luarocks
      pkgs.luaPackages.tree-sitter-cli
      pkgs.unzip
      pkgs.gnutar
      pkgs.gzip
    ]
    ++
      lib.optionals
        (hasAnyTagOf [
          "desktop"
          "laptop"
        ])
        [
          pkgs.julia
        ];

    programs = {
      neovim = {
        enable = true;
        # the config is the symlinked nvim dir, don't write an init.lua over it
        sideloadInitLua = true;
        extraPackages = config.editorTools.packages;
      };
      ripgrep.enable = true;
      fd.enable = true;
      npm.enable = true;
    };
    xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink config.fk.neovim.configDir;
  };
}
