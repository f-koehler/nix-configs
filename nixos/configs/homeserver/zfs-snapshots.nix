{ config, ... }:
{
  imports = [ ./lib/zfs-snapshots.nix ];
  config.homeserver.zfsSnapshots = {
    enable = true;
    services = {
      jellyfin = { };
      nextcloud = { };
      paperless = { };
      postgresql = { };
      tinymediamanager = { };
    };
  };
}
