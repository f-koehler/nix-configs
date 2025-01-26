{ pkgs, ... }:
let
  inherit (pkgs) kanshi wezterm;
  rofi = pkgs.rofi-wayland;
in
{
  catppuccin.sway = {
    enable = true;
    flavor = "mocha";
  };
  wayland = {
    systemd.target = "sway-session.target";
    windowManager.sway = {
      enable = true;
      wrapperFeatures = {
        base = true;
        gtk = true;
      };
      systemd.enable = true;
      config = {
        bars = [ ];
        focus.followMouse = false;
        menu = "${rofi}/bin/rofi -show drun";
        modifier = "Mod4";
        terminal = "${wezterm}/bin/wezterm";
        gaps.smartBorders = "no_gaps";
        workspaceAutoBackAndForth = true;
        floating = {
          border = 2;
          titlebar = true;
        };
        window = {
          border = 2;
          hideEdgeBorders = "smart";
          titlebar = false;
        };
      };
    };
  };

  home.packages = [ kanshi ];
}
