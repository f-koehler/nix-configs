{
  lib,
  pkgs,
  isWorkstation,
  ...
}:
lib.mkIf (pkgs.stdenv.isLinux && isWorkstation) {
  home.packages = with pkgs; [
    swaynotificationcenter
    waybar
    rofi-wayland
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = with pkgs.hyprlandPlugins; [
      hy3
    ];
    settings = lib.mkIf pkgs.stdenv.isLinux {
      "$mod" = "SUPER";
      "exec-once" = [
        "${pkgs.swaynotificationcenter}/bin/swaync"
        "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
        "${pkgs.waybar}/bin/waybar"
      ];
      animations = {
        enabled = "yes";
      };
      bindl = [
        ", switch:off:Lid Switch,exec,hyprctl keyword monitor \"eDP-1, 1920x1080@60, 0x0, 1\""
        ", switch:on:Lid Switch,exec,hyprctl keyword monitor \"eDP-1, disable\""
      ];
      bind = [
        "$mod, return, exec, ${pkgs.wezterm}/bin/wezterm"
        "$mod, d, exec, ${pkgs.rofi-wayland}/bin/rofi -show drun"
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
        "$mod, F1, workspace, 11"
        "$mod, F2, workspace, 12"
        "$mod, F3, workspace, 13"
        "$mod, F4, workspace, 14"
        "$mod, F5, workspace, 15"
        "$mod, F6, workspace, 16"
        "$mod, F7, workspace, 17"
        "$mod, F8, workspace, 18"
        "$mod, F9, workspace, 19"
        "$mod, F10, workspace, 20"

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
        "$mod+SHIFT, F1, hy3:movetoworkspace, 11"
        "$mod+SHIFT, F2, hy3:movetoworkspace, 12"
        "$mod+SHIFT, F3, hy3:movetoworkspace, 13"
        "$mod+SHIFT, F4, hy3:movetoworkspace, 14"
        "$mod+SHIFT, F5, hy3:movetoworkspace, 15"
        "$mod+SHIFT, F6, hy3:movetoworkspace, 16"
        "$mod+SHIFT, F7, hy3:movetoworkspace, 17"
        "$mod+SHIFT, F8, hy3:movetoworkspace, 18"
        "$mod+SHIFT, F9, hy3:movetoworkspace, 19"
        "$mod+SHIFT, F10, hy3:movetoworkspace, 20"

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

        drop_shadow = "yes";
        shadow_range = 4;
        shadow_render_power = 3;
        # col.shadow = "rgba(1a1a1aee)"
      };
      general = {
        layout = "hy3";
      };
    };
  };
}
