{ config, ... }:
let
  ip = "100.104.64.71";
in
{
  fileSystems = {
    "/export/media0" = {
      device = "/media/tank0/media";
      options = [
        "bind"
        "x-systemd.requires=zfs-mount.service"
      ];
    };
    "/export/media1" = {
      device = "/media/tank1/media";
      options = [
        "bind"
        "x-systemd.requires=zfs-mount.service"
      ];
    };
  };
  services.nfs.server = {
    enable = true;
    lockdPort = 4001;
    mountdPort = 4002;
    statdPort = 4000;
    exports = ''
      /export        ${ip}(rw,fsid=0,no_subtree_check)
      /export/media0 ${ip}(rw,nohide,insecure,no_subtree_check)
      /export/media1 ${ip}(rw,nohide,insecure,no_subtree_check)
    '';
  };
  networking.firewall.interfaces.tailscale0 = {
    allowedTCPPorts = [
      config.services.nfs.server.statdPort
      config.services.nfs.server.mountdPort
      config.services.nfs.server.lockdPort
      111
      2049
      20048
    ];
    allowedUDPPorts = [
      config.services.nfs.server.statdPort
      config.services.nfs.server.mountdPort
      config.services.nfs.server.lockdPort
      111
      2049
      20048
    ];
  };
}
