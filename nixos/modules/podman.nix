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
  };
  systemd.user.services."podman-compose@" = {
    description = "Description=%i rootless pod (podman-compose)";
    wantedBy = ["default.target"];
    path = with pkgs; [
      podman
      podman-compose
      shadow # for newuidmap
      su # for newuidmap
    ];
    serviceConfig = {
      Type = "simple";
      EnvironmentFile = "%h/.config/containers/compose/projects/%i.env";
      ExecStart = "${pkgs.podman-compose}/bin/podman-compose up";
      ExecStop = "${pkgs.podman-compose}/bin/podman-compose down";
    };
  };
}
