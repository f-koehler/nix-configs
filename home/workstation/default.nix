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
      ./ghostty.nix
      ./lapce.nix
      ./mpd.nix
      ./vscode.nix
      ./wezterm.nix
      ./zed.nix
    ]
    ++ lib.optionals isLinux [
      # ./hyprland
      ./sway
      # ./krohnkite.nix
      # ./plasma.nix
    ];
}
