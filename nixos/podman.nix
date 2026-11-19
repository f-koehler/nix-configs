{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.fk.podman.enable = lib.mkEnableOption "podman with weekly pruning";

  config = lib.mkIf config.fk.podman.enable {
    environment.systemPackages = [
      pkgs.podman-compose
    ];
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };
}
