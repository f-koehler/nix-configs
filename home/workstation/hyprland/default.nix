{
  inputs,
  config,
  lib,
  pkgs,
  isLinux,
  nodeConfig,
  ...
}:
let
  borderWidth = 1;
in
{
  imports = [
    ./ashell.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./hyprpolkitagent.nix
    ./hyprsunset.nix
    ./hypridle.nix
    ./kanshi.nix
    ./swaync.nix
    ./swayosd.nix

    ../sway/rofi.nix
  ];
  home = {
    packages = [
      pkgs.swaynotificationcenter
      pkgs.nerd-fonts.symbols-only
    ];
    pointerCursor.hyprcursor.enable = true;
  };
  catppuccin.hyprland = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
  };
  wayland.systemd.target = "graphical-session.target";
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${nodeConfig.system}.hyprland;
    systemd = {
      enable = false; # we use UWSM in NixOS config for Hyprland
    };
    xwayland.enable = true;
    plugins = [
      inputs.hy3.packages.${nodeConfig.system}.hy3
    ];
    settings = lib.mkIf isLinux {
      monitor = [
        "eDP-1, 1920x1200@60Hz, auto, 1"
      ];
      workspace = [
        "1,  gapsin:0, gapsout:0"
        "2,  gapsin:0, gapsout:0"
        "3,  gapsin:0, gapsout:0"
        "4,  gapsin:0, gapsout:0"
        "5,  gapsin:0, gapsout:0"
        "6,  gapsin:0, gapsout:0"
        "7,  gapsin:0, gapsout:0"
        "8,  gapsin:0, gapsout:0"
        "9,  gapsin:0, gapsout:0"
        "10, gapsin:0, gapsout:0"
      ];
      "$mod" = "SUPER";
      animations = {
        enabled = "yes";
      };
      windowrulev2 = [
        "opacity 0.0 override, class:^(xwaylandvideobridge)$"
        "noanim, class:^(xwaylandvideobridge)$"
        "noinitialfocus, class:^(xwaylandvideobridge)$"
        "maxsize 1 1, class:^(xwaylandvideobridge)$"
        "noblur, class:^(xwaylandvideobridge)$"
        "nofocus, class:^(xwaylandvideobridge)$"
      ];
      bindl = [
        ", XF86AudioPlay, exec, ${lib.getExe pkgs.playerctl} play-pause"
        ", XF86AudioPrev, exec, ${lib.getExe pkgs.playerctl} previous"
        ", XF86AudioNext, exec, ${lib.getExe pkgs.playerctl} next"
      ];
      binde = [
        "$mod, comma, resizeactive, -10 0"
        "$mod, period, resizeactive, 10 0"
        "$mod, less, resizeactive, 0 -10"
        "$mod, greater, resizeactive, 0 10"
      ];
      bind = [
        "$mod, return, exec, ${lib.getExe pkgs.alacritty}"
        "$mod, d, exec, ${lib.getExe' config.programs.rofi.finalPackage "rofi"} -show drun -run-command ''\"${lib.getExe' pkgs.uwsm "uwsm"} app -- {cmd}''\""
        "$mod+SHIFT, q, hy3:killactive"
        "$mod+SHIFT, e, exit"

        "$mod, h,     hy3:movefocus, l"
        "$mod, j,     hy3:movefocus, d"
        "$mod, k,     hy3:movefocus, u"
        "$mod, l,     hy3:movefocus, r"
        "$mod, left,  hy3:movefocus, l"
        "$mod, down,  hy3:movefocus, d"
        "$mod, up,    hy3:movefocus, u"
        "$mod, right, hy3:movefocus, r"

        "$mod+CONTROL, h, hy3:movefocus, l, visible"
        "$mod+CONTROL, j, hy3:movefocus, d, visible"
        "$mod+CONTROL, k, hy3:movefocus, u, visible"
        "$mod+CONTROL, l, hy3:movefocus, r, visible"
        "$mod+CONTROL, left, hy3:movefocus, l, visible"
        "$mod+CONTROL, down, hy3:movefocus, d, visible"
        "$mod+CONTROL, up, hy3:movefocus, u, visible"
        "$mod+CONTROL, right, hy3:movefocus, r, visible"

        "$mod+SHIFT, h, hy3:movewindow, l, once"
        "$mod+SHIFT, j, hy3:movewindow, d, once"
        "$mod+SHIFT, k, hy3:movewindow, u, once"
        "$mod+SHIFT, l, hy3:movewindow, r, once"
        "$mod+SHIFT, left, hy3:movewindow, l, once"
        "$mod+SHIFT, down, hy3:movewindow, d, once"
        "$mod+SHIFT, up, hy3:movewindow, u, once"
        "$mod+SHIFT, right, hy3:movewindow, r, once"

        "$mod+CONTROL+SHIFT, h, hy3:movewindow, l, once, visible"
        "$mod+CONTROL+SHIFT, j, hy3:movewindow, d, once, visible"
        "$mod+CONTROL+SHIFT, k, hy3:movewindow, u, once, visible"
        "$mod+CONTROL+SHIFT, l, hy3:movewindow, r, once, visible"
        "$mod+CONTROL+SHIFT, left, hy3:movewindow, l, once, visible"
        "$mod+CONTROL+SHIFT, down, hy3:movewindow, d, once, visible"
        "$mod+CONTROL+SHIFT, up, hy3:movewindow, u, once, visible"
        "$mod+CONTROL+SHIFT, right, hy3:movewindow, r, once, visible"

        "$mod, 1, workspace, 01"
        "$mod, 2, workspace, 02"
        "$mod, 3, workspace, 03"
        "$mod, 4, workspace, 04"
        "$mod, 5, workspace, 05"
        "$mod, 6, workspace, 06"
        "$mod, 7, workspace, 07"
        "$mod, 8, workspace, 08"
        "$mod, 9, workspace, 09"
        "$mod, 0, workspace, 10"

        "$mod+SHIFT, 1, hy3:movetoworkspace, 01"
        "$mod+SHIFT, 2, hy3:movetoworkspace, 02"
        "$mod+SHIFT, 3, hy3:movetoworkspace, 03"
        "$mod+SHIFT, 4, hy3:movetoworkspace, 04"
        "$mod+SHIFT, 5, hy3:movetoworkspace, 05"
        "$mod+SHIFT, 6, hy3:movetoworkspace, 06"
        "$mod+SHIFT, 7, hy3:movetoworkspace, 07"
        "$mod+SHIFT, 8, hy3:movetoworkspace, 08"
        "$mod+SHIFT, 9, hy3:movetoworkspace, 09"
        "$mod+SHIFT, 0, hy3:movetoworkspace, 10"

        "$mod+CONTROL, 1, hy3:focustab, index, 01"
        "$mod+CONTROL, 2, hy3:focustab, index, 02"
        "$mod+CONTROL, 3, hy3:focustab, index, 03"
        "$mod+CONTROL, 4, hy3:focustab, index, 04"
        "$mod+CONTROL, 5, hy3:focustab, index, 05"
        "$mod+CONTROL, 6, hy3:focustab, index, 06"
        "$mod+CONTROL, 7, hy3:focustab, index, 07"
        "$mod+CONTROL, 8, hy3:focustab, index, 08"
        "$mod+CONTROL, 9, hy3:focustab, index, 09"
        "$mod+CONTROL, 0, hy3:focustab, index, 10"

        "$mod, f, fullscreen, 1"
        "$mod+SHIFT, SPACE, togglefloating"

        "$mod, v, hy3:makegroup, v"
        "$mod, h, hy3:makegroup, h"
        "$mod, w, hy3:changegroup, tab"
        "$mod, e, hy3:changegroup, untab"
      ];
      decoration = {
        rounding = 5;

        blur = {
          enabled = "yes";
          size = 7;
          passes = 4;
          noise = 0.008;
          contrast = 0.8916;
          brightness = 0.8;
        };
      };
      exec-once = [
        "systemctl --user start hyprpolkitagent.service"
      ];
      general = {
        layout = "hy3";
      };
      input = {
        follow_mouse = 2;
      };
      plugin = {
        hy3 = {
          tabs = {
            "border_width" = borderWidth;
            "col.active" = "rgba(1e1e2eff)";
            "col.active.border" = "rgba(cba6f7ff)";
            "col.active.text" = "rgba(cdd6f4ff)";
            "col.urgent" = "rgba(1e1e2eff)";
            "col.urgent.border" = "rgba(eba0acff)";
            "col.urgent.text" = "rgba(cdd6f4ff)";
            "col.inactive" = "rgba(181825ff)";
            "col.inactive.border" = "rgba(6c7086ff)";
            "col.inactive.text" = "rgba(a6adc8ff)";
          };
        };
      };
    };
  };
}
