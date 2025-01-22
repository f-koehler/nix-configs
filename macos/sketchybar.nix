{
  pkgs,
  outputs,
  nodeConfig,
  ...
}:
let
  inherit (outputs.packages.${nodeConfig.system}) sketchybar-lua;
in
{
  environment.systemPackages = [
    pkgs.sketchybar-app-font
    pkgs.sketchybar
    sketchybar-lua
  ];
  homebrew.casks = [
    "sf-symbols"
    "font-sf-mono"
    "font-sf-pro"
  ];
}
