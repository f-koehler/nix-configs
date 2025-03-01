{
  pkgs,
  lib,
  config,
  ...
}:
let
  swaymsg = lib.getExe' config.wayland.windowManager.sway.package "swaymsg";
  script-work = pkgs.writeShellApplication {
    name = "kanshi-script-work";
    runtimeInputs = [ config.wayland.windowManager.sway.package ];
    text = ''
      set -eufo pipefail

      for ws in 1 2 3 4 5; do
        ${swaymsg} [workspace=$ws] move workspace to output DP-3
      done
      for ws in 6 7 8 9 10; do
        ${swaymsg} [workspace=$ws] move workspace to output eDP-1
      done
    '';
  };
  script-home = pkgs.writeShellApplication {
    name = "kanshi-script-home";
    runtimeInputs = [ config.wayland.windowManager.sway.package ];
    text = ''
      set -eufo pipefail

      for ws in 1 2 3 4 5; do
        ${swaymsg} [workspace=$ws] move workspace to output DP-3
      done
      for ws in 6 7 8 9 10; do
        ${swaymsg} [workspace=$ws] move workspace to output eDP-1
      done
    '';
  };
  script-mobile = pkgs.writeShellApplication {
    name = "kanshi-script-home";
    runtimeInputs = [ config.wayland.windowManager.sway.package ];
    text = ''
      set -eufo pipefail

      for ws in 1 2 3 4 5 6 7 8 9 10; do
        ${swaymsg} [workspace=$ws] move workspace to output DP-3
      done
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
          exec = "${lib.getExe script-work}";
          outputs = [
            {
              criteria = "eDP-1";
              mode = "1920x1200";
              position = "2560,-1000";
            }
            {
              criteria = "Dell Inc. DELL S2722DC 82CRGD3";
              mode = "2560x1440@75";
              position = "0,0";
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
