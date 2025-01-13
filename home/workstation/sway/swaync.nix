{
  lib,
  pkgs,
  config,
  ...
}:
{
  services = {
    swaync = {
      enable = true;
    };
  };
  wayland.windowManager.sway.config.keybindings =
    let
      inherit (config.wayland.windowManager.sway.config) modifier;
    in
    lib.mkOptionDefault {
      "${modifier}+Shift+n" =
        "${pkgs.swaynotificationcenter}/bin/swaync-client --toggle-panel --skip-wait";
    };
}
