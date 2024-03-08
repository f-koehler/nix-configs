{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    slirp4netns
    fuse-overlayfs
    podman-compose
    crun
  ];
  virtualisation.podman = {
    enable = true;
  };
}
