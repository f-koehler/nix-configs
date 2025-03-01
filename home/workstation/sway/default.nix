{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./rofi.nix
    ./kanshi.nix
    ./swayosd.nix
  ];
  services.network-manager-applet.enable = true;
  wayland = {
    #   systemd.target = "graphical-session.target";
    windowManager.sway = {
      enable = true;
      #     systemd.enable = false; # we use UWSM for session management
      wrapperFeatures = {
        base = true;
        gtk = true;
      };
      xwayland = true;
      config = {
        modifier = "Mod4";
        #       bars = [ ];
        menu = "${lib.getExe' config.programs.rofi.finalPackage "rofi"} -show drun -run-command ''\"${lib.getExe' pkgs.uwsm "uwsm"} app -- {cmd}''\"";
        terminal = "${lib.getExe' pkgs.uwsm "uwsm"} app -- ${lib.getExe' config.programs.alacritty.package "alacritty"}";
        focus = {
          followMouse = false;
          mouseWarping = true;
        };
        gaps = {
          smartBorders = "on";
          smartGaps = false;
        };
        window.titlebar = false;
        workspaceAutoBackAndForth = true;
        workspaceOutputAssign = [
          {
            workspace = "1";
            output = "DP-1,eDP-1";
          }
          {
            workspace = "2";
            output = "DP-1,eDP-1";
          }
          {
            workspace = "3";
            output = "DP-1,eDP-1";
          }
          {
            workspace = "4";
            output = "DP-1,eDP-1";
          }
          {
            workspace = "5";
            output = "DP-1,eDP-1";
          }
          {
            workspace = "6";
            output = "eDP-1";
          }
          {
            workspace = "7";
            output = "eDP-1";
          }
          {
            workspace = "8";
            output = "eDP-1";
          }
          {
            workspace = "9";
            output = "eDP-1";
          }
          {
            workspace = "10";
            output = "eDP-1";
          }
        ];
      };
    };
  };
}
