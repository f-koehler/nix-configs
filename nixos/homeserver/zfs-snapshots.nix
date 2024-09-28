_: {
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
}
