{
  lib,
  config,
  pkgs,
  nodeConfig,
  ...
}:
{
  imports = [
    ./rofi.nix
    # ./kanshi.nix
    ./swayosd.nix
    ./swaync.nix
    # ./swaylock.nix
    # ./swayidle.nix
  ];
  services = {
    network-manager-applet.enable = true;
    gnome-keyring.enable = true;
  };
  stylix.targets.sway.enable = config.wayland.windowManager.sway.enable;
  wayland = {
    windowManager.sway = {
      enable = true;
      extraOptions = lib.optionals (builtins.elem "nvidia" nodeConfig.gpus) [ "--unsupported-gpu" ];
      wrapperFeatures = {
        base = true;
        gtk = true;
      };
      xwayland = true;
      config = {
        modifier = "Mod4";
        menu = "${lib.getExe' config.programs.rofi.finalPackage "rofi"} -show drun -run-command ''\"${lib.getExe' pkgs.uwsm "uwsm"} app -- {cmd}''\"";
        terminal = "${lib.getExe' config.programs.alacritty.package "alacritty"}";
        focus = {
          followMouse = false;
          mouseWarping = true;
        };
        gaps = {
          smartBorders = "on";
          smartGaps = false;
        };
        output = {
          "DP-4" = {
            # mode = "3840x2160@199.999";
            # pos = "0 0";
            scale = "1.35";
            adaptive_sync = "on";
            render_bit_depth = "10";
          };
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
