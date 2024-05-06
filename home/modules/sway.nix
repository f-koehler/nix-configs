{pkgs, ...}: {
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "sway-session.target";
    };
    settings = {
      mainBar = {
        height = 22;
        spacing = 15;
        modules-left = ["sway/workspaces" "sway/mode"];
        modules-right = ["tray" "clock" "battery#BAT0" "custom/power"];
        tray = {
          spacing = 5;
        };
      };
    };
    style = ''
      * {
        font-family: Cascadia Code NF;
        font-size: 10px;
        margin: 0;
      }
    '';
  };
  wayland.windowManager.sway = {
    enable = true;
    systemd = {
      enable = true;
      xdgAutostart = true;
    };
    config = {
      bars = [];
      focus.followMouse = false;
      menu = "${pkgs.rofi-wayland}/bin/rofi -show drun";
      modifier = "Mod4";
      terminal = "${pkgs.wezterm}/bin/wezterm";
    };
  };
}
