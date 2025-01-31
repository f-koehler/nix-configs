{
  lib,
  inputs,
  nodeConfig,
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland.settings.exec-once = [
    "${lib.getExe' pkgs.uwsm "uwsm"} app -- ${
      inputs.ashell.defaultPackage.${nodeConfig.system}
    }/bin/ashell"
  ];
  home.packages = [
    inputs.ashell.defaultPackage.${nodeConfig.system}
    pkgs.util-linux
  ];
}
