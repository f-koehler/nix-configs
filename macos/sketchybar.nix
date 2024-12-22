{
  lib,
  pkgs,
  outputs,
  nodeConfig,
  ...
}: let
  # inherit (outputs.packages.${nodeConfig.system}) sketchybar-config sketchybar-lua;
  # inherit (outputs.packages.${nodeConfig.system}) sketchybar-lua;
in {
  environment.systemPackages = [
    # TODO(fk): figure out why we cannot use pkgs.sketchybar-plugins
    # sketchybar-config
    pkgs.lua
    pkgs.sketchybar
  ];
  # services = {
  #   sketchybar = {
  #     enable = true;
  #     config = ''
  #       LUA_PATH=${sketchybar-lua}/lib ${lib.getExe pkgs.lua} ${sketchybar-lua}/share/sketchybar-config/init.lua
  #     '';
  #   };
  # };
}
