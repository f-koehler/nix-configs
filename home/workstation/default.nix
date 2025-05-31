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
      ./lapce.nix
      # ./mpd.nix
      ./vscode.nix
      ./wezterm.nix
      ./zed.nix
    ]
    ++ lib.optionals (builtins.elem "sway" nodeConfig.desktops) [ ./sway ]
    ++ lib.optionals (builtins.elem "plasma" nodeConfig.desktops) [ ./plasma.nix ];
}
