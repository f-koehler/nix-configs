{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    slirp4netns
    fuse-overlayfs
    podman
    podman-compose
    crun
  ];
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerCompat = true;
  };
}
