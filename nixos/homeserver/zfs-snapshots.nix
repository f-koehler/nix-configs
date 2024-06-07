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
  };
}
