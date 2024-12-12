{config, ...}: {
  imports = [./lib/zfs-snapshots.nix];
  config.homeserver.zfsSnapshots = {
    enable = true;
    services = {
      audiobookshelf = {};
      jellyfin = {};
      navidrome = {};
      nextcloud = {};
      paperless = {};
      postgresql = {};
      tinymediamanager = {};
    };
  };
  users.users.${config.syncoid.user}.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBSATjLjRE6lpk/e4wmPiyeCN5c+WMAmzm0caEP3pPmE fkoehler@vps"];
}
