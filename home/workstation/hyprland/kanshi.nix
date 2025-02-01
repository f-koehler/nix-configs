{
  inputs,
  lib,
  pkgs,
  nodeConfig,
  ...
}:
let
  inherit (inputs.hyprland.packages.${nodeConfig.system}) hyprland;
  script-home = pkgs.writeShellApplication {
    name = "kanshi-script-home";
    runtimeInputs = [ hyprland ];
    text = ''
      set -eufo pipefail
      hyprctl keyword workspace 1,monitor:DP-3
      hyprctl keyword workspace 2,monitor:DP-3
      hyprctl keyword workspace 3,monitor:DP-3
      hyprctl keyword workspace 4,monitor:DP-3
      hyprctl keyword workspace 5,monitor:DP-3
      hyprctl keyword workspace 6,monitor:eDP-1
      hyprctl keyword workspace 7,monitor:eDP-1
      hyprctl keyword workspace 8,monitor:eDP-1
      hyprctl keyword workspace 9,monitor:eDP-1
      hyprctl keyword workspace 10,monitor:eDP-1

      hyprctl dispatch moveworkspacetomonitor 1 DP-3 || true
      hyprctl dispatch moveworkspacetomonitor 2 DP-3 || true
      hyprctl dispatch moveworkspacetomonitor 3 DP-3 || true
      hyprctl dispatch moveworkspacetomonitor 4 DP-3 || true
      hyprctl dispatch moveworkspacetomonitor 5 DP-3 || true
      hyprctl dispatch moveworkspacetomonitor 6 eDP-1 || true
      hyprctl dispatch moveworkspacetomonitor 7 eDP-1 || true
      hyprctl dispatch moveworkspacetomonitor 8 eDP-1 || true
      hyprctl dispatch moveworkspacetomonitor 9 eDP-1 || true
      hyprctl dispatch moveworkspacetomonitor 10 eDP-1 || true
    '';
  };
  script-mobile = pkgs.writeShellApplication {
    name = "kanshi-script-work";
    runtimeInputs = [ hyprland ];
    text = ''
      set -eufo pipefail
      hyprctl keyword workspace 1,monitor:eDP-1
      hyprctl keyword workspace 2,monitor:eDP-1
      hyprctl keyword workspace 3,monitor:eDP-1
      hyprctl keyword workspace 4,monitor:eDP-1
      hyprctl keyword workspace 5,monitor:eDP-1
      hyprctl keyword workspace 6,monitor:eDP-1
      hyprctl keyword workspace 7,monitor:eDP-1
      hyprctl keyword workspace 8,monitor:eDP-1
      hyprctl keyword workspace 9,monitor:eDP-1
      hyprctl keyword workspace 10,monitor:eDP-1

      hyprctl dispatch moveworkspacetomonitor 1 eDP-1-3 || true
      hyprctl dispatch moveworkspacetomonitor 2 eDP-1 || true
      hyprctl dispatch moveworkspacetomonitor 3 eDP-1 || true
      hyprctl dispatch moveworkspacetomonitor 4 eDP-1 || true
      hyprctl dispatch moveworkspacetomonitor 5 eDP-1 || true
      hyprctl dispatch moveworkspacetomonitor 6 eDP-1 || true
      hyprctl dispatch moveworkspacetomonitor 7 eDP-1 || true
      hyprctl dispatch moveworkspacetomonitor 8 eDP-1 || true
      hyprctl dispatch moveworkspacetomonitor 9 eDP-1 || true
      hyprctl dispatch moveworkspacetomonitor 10 eDP-1 || true
    '';
  };
in
{
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile = {
          name = "work";
          outputs = [
            {
              criteria = "eDP-1";
              mode = "1920x1200";
              position = "0,0";
            }
            {
              criteria = "Lenovo Group Limited LEN L27m-28 U45XPDF3";
              mode = "1920x1080";
              position = "0,-1080";
            }
          ];
        };
      }
      {
        profile = {
          name = "home";
          exec = "${lib.getExe script-home}";
          outputs = [
            {
              criteria = "eDP-1";
              mode = "1920x1200";
              position = "320,1440";
              scale = 1.0;
            }
            {
              criteria = "LG Electronics LG ULTRAGEAR+ 202NTDV2S306";
              mode = "3840x2160@120";
              position = "0,0";
              scale = 1.5;
            }
          ];
        };
      }
      {
        profile = {
          name = "mobile";
          exec = "${lib.getExe script-mobile}";
          outputs = [
            {
              criteria = "eDP-1";
              mode = "1920x1200";
              position = "0,0";
              scale = 1.0;
            }
          ];
        };
      }
    ];
  };
}
