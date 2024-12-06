_: {
  services.swayosd = {
    enable = true;
  };
  wayland.windowManager.hyprland = {
    settings = {
      # Works with input inhibitor active (l)
      bindl = [
        ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
        ", XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
      ];

      # Works with input inhibitor active (l) and can be repeated (e)
      bindle = [
        ", XF86AudioRaiseVolume,  exec, swayosd-client --output-volume raise"
        ", XF86AudioLowerVolume,  exec, swayosd-client --output-volume lower"
        ", XF86MonBrightnessUp,   exec, swayosd-client --brightness raise"
        ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
      ];

      # Works with input inhibitor active (l) and is triggered on release (r)
      bindrl = [
        ", Ca[s+Lock, exec, swayosd-client --caps-lock"
      ];
    };
  };
}
