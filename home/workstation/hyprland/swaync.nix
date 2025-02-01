{ lib, pkgs, ... }:
{
  services.swaync.enable = true;
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        "$mod SHIFT, N, exec, ${pkgs.swaynotificationcenter}/bin/swaync-client --toggle-panel --skip-wait"
      ];
    };
  };
}
