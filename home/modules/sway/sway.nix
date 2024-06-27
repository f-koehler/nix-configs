{pkgs, ...}: let
  inherit (pkgs) kanshi swayosd swaylock wezterm networkmanagerapplet blueman;
  rofi = pkgs.rofi-wayland;
  swaync = pkgs.swaynotificationcenter;
in {
  programs = {
    swaylock = {
      enable = true;
      package = swaylock;
    };
  };
  wayland.windowManager.sway = rec {
    enable = true;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    systemd = {
      enable = true;
      # xdgAutostart = true;
    };
    config = {
      bars = [];
      focus.followMouse = false;
      menu = "${rofi}/bin/rofi -show drun";
      modifier = "Mod4";
      terminal = "${wezterm}/bin/wezterm";
      startup = [
        {
          command = "${swaync}/bin/swaync";
        }
        {
          command = "${swayosd}/bin/swaysosd-server";
        }
        {
          command = "${networkmanagerapplet}/bin/networkmanagerapplet --indicator";
        }
        {
          command = "${blueman}/bin/blueman-applet";
        }
      ];
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
  services = {
    swaync.enable = true;
    swayosd.enable = true;
  };

  home.packages = [kanshi];
}
