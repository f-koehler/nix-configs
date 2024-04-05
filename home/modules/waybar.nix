{
  lib,
  pkgs,
  ...
}: {
  programs.waybar = lib.mkIf (pkgs.stdenv.isLinux && pkgs.stdenv.isLinux) {
    enable = true;
    # wayland.windowManager.hyprland.settings."exec-once" = ["waybar"];
  };
}
