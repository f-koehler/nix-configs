{ lib, pkgs, ... }:
{
  # services.swayosd = {
  #   enable = true;
  # };
  # systemd.user.services."swayosd".Service.ExecStart = lib.mkForce "${lib.getExe' pkgs.uwsm "uwsm"} app -- ${lib.getExe' pkgs.swayosd "swayosd-server"}";
  wayland.windowManager.hyprland = {
    settings =
      let
        client = lib.getExe' pkgs.swayosd "swayosd-client";
      in
      {
        exec-once = [
          "${lib.getExe' pkgs.uwsm "uwsm"} app -- ${lib.getExe' pkgs.swayosd "swayosd-server"}"
        ];

        # Works with input inhibitor active (l)
        bindl = [
          ", XF86AudioMute,    exec, ${client} --output-volume mute-toggle"
          ", XF86AudioMicMute, exec, ${client} --input-volume mute-toggle"
        ];

        # Works with input inhibitor active (l) and can be repeated (e)
        bindle = [
          ", XF86AudioRaiseVolume,  exec, ${client} --output-volume raise"
          ", XF86AudioLowerVolume,  exec, ${client} --output-volume lower"
          ", XF86MonBrightnessUp,   exec, ${client} --brightness raise"
          ", XF86MonBrightnessDown, exec, ${client} --brightness lower"
        ];

        # Works with input inhibitor active (l) and is triggered on release (r)
        bindrl = [
          ", Caps+Lock, exec, ${client} --caps-lock" # TODO(fk): caps lock indicator not working
        ];
      };
  };
}
