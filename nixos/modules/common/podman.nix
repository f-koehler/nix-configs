{pkgs, ...}: {
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
}
