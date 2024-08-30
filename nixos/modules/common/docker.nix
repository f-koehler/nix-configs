{
  lib,
  username,
  isWorkstation,
  containerBackend,
  ...
}:
lib.mkIf (containerBackend == "docker") {
  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
    };
    oci-containers.backend = "docker";
  };
  users.users.${username}.extraGroups = lib.optionals isWorkstation ["docker"];
}
