{
  lib,
  isLinux,
  ...
}: {
  imports =
    [
      ./alacritty.nix
      # ./email.nix
      ./vscode.nix
      ./wezterm.nix
      ./zed.nix
    ]
    ++ lib.optionals isLinux [
      # ./hyprland
      # ./sway
      # ./krohnkite.nix
      # ./plasma.nix
    ];
}
