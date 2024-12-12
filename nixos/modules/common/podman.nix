{
  lib,
  pkgs,
  nodeConfig,
  ...
}:
lib.mkIf (nodeConfig.containerBackend == "podman") {
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
  users.users.${nodeConfig.username}.extraGroups = lib.optionals nodeConfig.isWorkstation ["podman"];
}
