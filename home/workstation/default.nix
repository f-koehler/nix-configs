{
  lib,
  isLinux,
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
    ++ lib.optionals isLinux [
      ./sway
      # ./plasma.nix
    ];
}
