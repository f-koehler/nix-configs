{
  lib,
  pkgs,
  ...
}: {
  services.swayosd = {
    enable = true;
  };
  wayland.windowManager.sway.config = let
    swayosd-client = "${pkgs.swayosd}/bin/swayosd-client";
  in {
    keybindings = lib.mkOptionDefault {
      "XF86AudioRaiseVolume" = "exec ${swayosd-client} --output-volume raise";
      "XF86AudioLowerVolume" = "exec  ${swayosd-client} --output-volume lower";
      "XF86AudioMute" = "exec ${swayosd-client} --output-volume mute-toggle";
      "XF86AudioMicMute" = "exec ${swayosd-client} --input-volume mute-toggle";
      "XF86MonBrightnessUp" = "exec ${swayosd-client} --brightness raise";
      "XF86MonBrightnessDown" = "exec ${swayosd-client} --brightness lower";
      "--release Caps_Lock" = "exec ${swayosd-client} --caps-lock";
    };
  };
}
