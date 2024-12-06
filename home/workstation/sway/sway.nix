{pkgs, ...}: let
  inherit (pkgs) kanshi swayosd swaylock wezterm;
  rofi = pkgs.rofi-wayland;
  swaync = pkgs.swaynotificationcenter;
in {
  wayland.windowManager.sway = rec {
    enable = true;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    config = {
      bars = [];
      focus.followMouse = false;
      menu = "${rofi}/bin/rofi -show drun";
      modifier = "Mod4";
      terminal = "${wezterm}/bin/wezterm";
      startup = let
        services = [
          # "blueman-applet"
          "kanshi"
          # "networkmanagerapplet"
          "swaync"
          "swayosd"
          "waybar"
        ];
        toStartup = service: {command = "systemctl start --user ${service}.service";};
      in
        map toStartup services;
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
    extraConfig = ''
      bindsym ${config.modifier}+Shift+n exec ${swaync}/bin/swaync-client -t -sw
      bindsym ${config.modifier}+Shift+z exec ${swaylock}/bin/swaylock
      bindsym ${config.modifier}+Shift+r exec ${pkgs.sway}/bin/swaymsg reload

      bindsym XF86AudioRaiseVolume exec  ${swayosd}/bin/swayosd-client --output-volume raise
      bindsym XF86AudioLowerVolume exec  ${swayosd}/bin/swayosd-client --output-volume lower
      bindsym XF86AudioMute exec         ${swayosd}/bin/swayosd-client --output-volume mute-toggle
      bindsym XF86AudioMicMute exec      ${swayosd}/bin/swayosd-client --input-volume mute-toggle
      bindsym --release Caps_Lock   exec ${swayosd}/bin/swayosd-client --caps-lock
      bindsym XF86MonBrightnessUp   exec ${swayosd}/bin/swayosd-client --brightness raise
      bindsym XF86MonBrightnessDown exec ${swayosd}/bin/swayosd-client --brightness lower
    '';
  };

  home.packages = [kanshi];
}
