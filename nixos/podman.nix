{ config, lib, ... }:
{
  options.fk.podman.enable = lib.mkEnableOption "podman with weekly pruning";

  config = lib.mkIf config.fk.podman.enable {
    virtualisation.podman = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };
}
