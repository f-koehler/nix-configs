{
  lib,
  nodeConfig,
  ...
}:
lib.mkIf (nodeConfig.containerBackend == "docker") {
  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
    };
    oci-containers.backend = "docker";
  };
  users.users.${nodeConfig.username}.extraGroups = lib.optionals nodeConfig.isWorkstation ["docker"];
}
