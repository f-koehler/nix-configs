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
        tinymediamanager = {
          autoprune = true;
          yearly = 1;
          monthly = 12;
          daily = 10;
          hourly = 72;
        };
        hass = {
          autoprune = true;
          yearly = 1;
          monthly = 12;
          daily = 30;
          hourly = 96;
        };
        uptime-kuma = {
          autoprune = true;
          yearly = 1;
          monthly = 12;
          daily = 30;
          hourly = 96;
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
        "rpool/tinymediamanager" = {
          autosnap = true;
          useTemplate = ["tinymediamanager"];
        };
        "rpool/hass" = {
          autosnap = true;
          useTemplate = ["hass"];
        };
        "rpool/uptime-kuma" = {
          autosnap = true;
          useTemplate = ["uptime-kuma"];
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
        "tank1/backups/tinymediamanager" = {
          autosnap = false;
          useTemplate = ["tinymediamanager"];
        };
        "tank1/backups/hass" = {
          autosnap = false;
          useTemplate = ["hass"];
        };
        "tank1/backups/uptime-kuma" = {
          autosnap = false;
          useTemplate = ["uptime-kuma"];
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
        "tank1-tinymediamanager" = {
          source = "rpool/tinymediamanager";
          target = "tank1/backups/tinymediamanager";
        };
        "tank1-hass" = {
          source = "rpool/hass";
          target = "tank1/backups/hass";
        };
      };
    };
  };
}
