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
    pkgs.neovim
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
        pkgs.kdePackages.qtdeclarative # for qmlformat
      ];

  programs = {
    ripgrep.enable = true;
    fd.enable = true;
    npm.enable = true;
  };
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Code/nix-configs/home/neovim-config";
}
