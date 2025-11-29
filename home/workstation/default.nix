{
  pkgs,
  lib,
  nodeConfig,
  isLinux,
  ...
}:
{
  imports = [
    ./alacritty.nix
    ./email.nix
    ./firefox.nix
    ./fonts.nix
    ./gtk.nix
    ./qt.nix
    ./vscode.nix
    ./wezterm.nix
    ./zed.nix
  ]
  ++ lib.optionals (isLinux && (builtins.elem "plasma" nodeConfig.desktops)) [ ./plasma.nix ];

  home.packages = [ pkgs.devcontainer ];

  stylix.iconTheme = {
    enable = true;
  }
  // lib.mkIf isLinux {
    light = "breeze";
    dark = "breeze-dark";
    package = pkgs.kdePackages.breeze-icons;
  };
}
