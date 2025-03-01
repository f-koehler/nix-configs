{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./rofi.nix
    ./kanshi.nix
    ./swayosd.nix
  ];
  wayland = {
    systemd.target = "graphical-session.target";
    windowManager.sway = {
      enable = true;
      systemd.enable = false; # we use UWSM for session management
      wrapperFeatures = {
        base = true;
        gtk = true;
      };
      xwayland = true;
      config = {
        modifier = "Mod4";
        bars = [ ];
        menu = "${lib.getExe' config.programs.rofi.finalPackage "rofi"} -show drun -run-command ''\"${lib.getExe' pkgs.uwsm "uwsm"} app -- {cmd}''\"";
        terminal = "${lib.getExe' pkgs.uwsm "uwsm"} app -- ${lib.getExe' config.programs.alacritty.package "alacritty"}";
      };
    };
  };
}
