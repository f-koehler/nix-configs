{
  lib,
  nodeConfig,
  ...
}:
{
  imports =
    [
      ./alacritty.nix
      # ./email.nix
      ./gtk.nix
      ./lapce.nix
      # ./mpd.nix
      ./qt.nix
      ./vscode.nix
      ./wezterm.nix
      ./zed.nix
    ]
    ++ lib.optionals (builtins.elem "sway" nodeConfig.desktops) [ ./sway ]
    ++ lib.optionals (builtins.elem "plasma" nodeConfig.desktops) [ ./plasma.nix ];
}
