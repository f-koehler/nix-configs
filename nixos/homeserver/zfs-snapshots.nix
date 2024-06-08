_: {
  services = {
    sanoid = {
      enable = true;
      datasets = {
        "rpool/nextcloud" = {
          autosnap = true;
          autoprune = true;
          yearly = 1;
          monthly = 12;
          daily = 7;
          hourly = 48;
        };
        "rpool/postgresql" = {
          autosnap = true;
          autoprune = true;
          yearly = 1;
          monthly = 12;
          daily = 7;
          hourly = 48;
        };
        "rpool/audiobookshelf" = {
          autosnap = true;
          autoprune = true;
          yearly = 1;
          monthly = 12;
          daily = 7;
          hourly = 48;
        };
        "rpool/paperless" = {
          autosnap = true;
          autoprune = true;
          yearly = 3;
          monthly = 12;
          daily = 7;
          hourly = 48;
        };
      };
    };
    syncoid = {
      enable = true;
      commonArgs = ["--no-sync-snap"];
      commands = {
        "tank1-nextcloud" = {
          source = "rpool/nextcloud";
          target = "tank1/backups/nextcloud";
        };
        "tank1-postgresql" = {
          source = "rpool/postgresql";
          target = "tank1/backups/postgresql";
        };
        "tank1-paperless" = {
          source = "rpool/paperless";
          target = "tank1/backups/paperless";
        };
        "tank1-audiobookshelf" = {
          source = "rpool/audiobookshelf";
          target = "tank1/backups/audiobookshelf";
        };
      };
    };
  };
}
