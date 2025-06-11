{
  lib,
  pkgs,
  nodeConfig,
  ...
}:
lib.mkIf (nodeConfig.containerBackend == "docker") {
  environment.systemPackages = [ pkgs.docker-compose ];
  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
    };
    oci-containers.backend = "docker";
  };
  users.users.${nodeConfig.username}.extraGroups = lib.optionals nodeConfig.isWorkstation [
    "docker"
  ];
}
