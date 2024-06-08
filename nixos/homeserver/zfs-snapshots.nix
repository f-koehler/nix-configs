_: {
  services = {
    sanoid = {
      enable = true;
      templates = {
        nextcloud = {
          autoprune = true;
          yearly = 1;
          monthly = 12;
          daily = 7;
          hourly = 48;
        };
        postgresql = {
          autoprune = true;
          yearly = 1;
          monthly = 12;
          daily = 7;
          hourly = 48;
        };
        audiobookshelf = {
          autoprune = true;
          yearly = 1;
          monthly = 12;
          daily = 7;
          hourly = 48;
        };
        paperless = {
          autoprune = true;
          yearly = 3;
          monthly = 12;
          daily = 7;
          hourly = 48;
        };
      };
      datasets = {
        "rpool/nextcloud" = {
          autosnap = true;
          useTemplate = ["nextcloud"];
        };
        "rpool/postgresql" = {
          autosnap = true;
          useTemplate = ["postgresql"];
        };
        "rpool/audiobookshelf" = {
          autosnap = true;
          useTemplate = ["audiobookshelf"];
        };
        "rpool/paperless" = {
          autosnap = true;
          useTemplate = ["paperless"];
        };
        "tank1/backups/nextcloud" = {
          autosnap = false;
          useTemplate = ["nextcloud"];
        };
        "tank1/backups/postgresql" = {
          autosnap = false;
          useTemplate = ["postgresql"];
        };
        "tank1/backups/audiobookshelf" = {
          autosnap = false;
          useTemplate = ["audiobookshelf"];
        };
        "tank1/backups/paperless" = {
          autosnap = false;
          useTemplate = ["paperless"];
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
