{
  lib,
  pkgs,
  username,
  isWorkstation,
  containerBackend,
  ...
}:
lib.mkIf (containerBackend == "podman") {
  virtualisation = {
    podman = {
      enable = true;
      autoPrune.enable = true;
      dockerSocket.enable = true;
      dockerCompat = true;
    };
    oci-containers.backend = "podman";
  };
  environment.systemPackages = with pkgs; [
    podman-compose
  ];
  users.users.${username}.extraGroups = lib.optionals isWorkstation ["podman"];
}
