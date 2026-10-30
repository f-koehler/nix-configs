{
  config,
  lib,
  pkgs,
  hasAnyTagOf,
  ...
}:
{
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
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Code/nix-configs/home/neovim-config";
}
