{
  nodeConfig,
  lib,
  myLib,
  ...
}:
lib.mkIf nodeConfig.features.navidrome.enable (myLib.os.mkServiceUser "navidrome")
