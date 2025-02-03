{
  pkgs,
  lib,
  inputs,
  nodeConfig,
  ...
}:
let
  pidof = lib.getExe' pkgs.procps "pidof";
  hyprlock = lib.getExe' pkgs.hyprlock "hyprlock";
  loginctl = lib.getExe' pkgs.systemd "loginctl";
  systemctl = lib.getExe' pkgs.systemd "systemctl";
  hyprctl = lib.getExe' inputs.hyprland.packages.${nodeConfig.system}.hyprland "hyprctl";
  brightnessctl = lib.getExe' pkgs.brightnessctl "brightnessctl";
in
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "${pidof} hyprlock || ${hyprlock}"; # do not start multiple hyprlock instances
        before_sleep_cmd = "${loginctl} lock-session"; # lock before suspending
        after_sleep_cmd = "${hyprctl} dispatch dpms on";
      };
      listener = [
        {
          timeout = 150;
          on-timeout = "${brightnessctl} -s set 10";
          on-resume = "${brightnessctl} -r";
        }
        {
          timeout = 150;
          on-timeout = "${brightnessctl} -sd rgb:kbd_backlight set 0";
          on-resume = "${brightnessctl} -rd rgb:kbd_backlight";
        }
        {
          timeout = 300;
          on-timeout = "${loginctl} lock-session";
        }
        {
          timeout = 330;
          on-timeout = "${hyprctl} dispatch dpms off";
          on-resume = "${hyprctl} dispatch dpms on";
        }
        {
          timeout = 1800;
          on-timeout = "${systemctl} suspend";
        }
      ];
    };
  };
}
