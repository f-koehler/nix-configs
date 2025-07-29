{
  pkgs,
  lib,
  nodeConfig,
  isLinux,
  ...
}:
{
  imports =
    [
      ./alacritty.nix
      ./email.nix
      ./firefox.nix
      ./fonts.nix
      ./gtk.nix
      # ./mpd.nix
      ./qt.nix
      ./spotify.nix
      ./vscode.nix
      ./wezterm.nix
      ./zed.nix
    ]
    ++ lib.optionals (isLinux && (builtins.elem "sway" nodeConfig.desktops)) [ ./sway ]
    ++ lib.optionals (isLinux && (builtins.elem "plasma" nodeConfig.desktops)) [ ./plasma.nix ]
    ++ lib.optionals isLinux [ ./chromium.nix ];

  stylix.iconTheme = {
    enable = true;
    light = "breeze";
    dark = "breeze-dark";
    package = pkgs.kdePackages.breeze-icons;
  };
}
