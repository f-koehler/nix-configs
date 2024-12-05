{
  lib,
  pkgs,
  isWorkstation,
  isLinux,
  ...
}:
lib.mkIf (isLinux && isWorkstation) {
  home.packages = with pkgs; [
    swaynotificationcenter
    waybar
    rofi-wayland
  ];
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    Unit.Description = "polkit-gnome-authentication-agent-1";
    Install.WantedBy = ["hyprland-session.target"];
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = with pkgs.hyprlandPlugins; [
      hy3
    ];
    settings = lib.mkIf isLinux {
      "$mod" = "SUPER";
      animations = {
        enabled = "yes";
      };
      bindl = [
        ", XF86AudioPlay, exec, ${lib.getExe pkgs.playerctl} play-pause"
        ", XF86AudioPrev, exec, ${lib.getExe pkgs.playerctl} previous"
        ", XF86AudioNext, exec, ${lib.getExe pkgs.playerctl} next"
      ];
      bind = [
        "$mod, return, exec, ${lib.getExe pkgs.wezterm}"
        "$mod, d, exec, ${lib.getExe pkgs.rofi-wayland} -show drun"
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
