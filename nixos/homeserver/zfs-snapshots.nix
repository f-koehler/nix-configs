{lib, ...}: let
  hostedServices = [
    {name = "audiobookshelf";}
    {name = "gickup";}
    {
      name = "hass";
      units = ["podman-hass"];
    }
    {name = "jellyfin";}
    {
      name = "nextcloud";
      units = ["nextcloud-setup"];
      dense = true;
    }
    {
      name = "paperless";
      units = ["paperless-web" "paperless-consumer" "paperless-scheduler" "paperless-task-queue"];
      dense = true;
    }
    {name = "postgresql";}
    {
      name = "tinymediamanager";
      units = ["podman-tinymediamanager"];
    }
    {name = "uptime-kuma";}
  ];
in {
  fileSystems = builtins.listToAttrs (map (service: {
      name = "/var/lib/${service.name}";
      value = {
        device = "rpool/${service.name}";
        fsType = "zfs";
      };
    })
    hostedServices);
  services = {
    sanoid = {
      enable = true;
      datasets = lib.mkMerge [
        (builtins.listToAttrs
          (map (
              service: {
                name = "rpool/${service.name}";
                value = {
                  autosnap = true;
                  useTemplate = ["${service.name}"];
                };
              }
            )
            hostedServices))
        (builtins.listToAttrs
          (map (
              service: {
                name = "tank0/backups/${service.name}";
                value = {
                  autosnap = false;
                  useTemplate = ["${service.name}"];
                };
              }
            )
            hostedServices))
        (builtins.listToAttrs
          (map (
              service: {
                name = "tank1/backups/${service.name}";
                value = {
                  autosnap = false;
                  useTemplate = ["${service.name}"];
                };
              }
            )
            hostedServices))
      ];
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
        jellyfin = {
          autorune = true;
          yearly = 0;
          monthly = 2;
          daily = 7;
          hourly = 24;
        };
        gickup = {
          autorune = true;
          yearly = 1;
          monthly = 12;
          daily = 7;
          hourly = 24;
        };
      };
    };
    syncoid = {
      enable = true;
      commonArgs = ["--no-sync-snap"];
      commands = lib.mkMerge [
        (builtins.listToAttrs
          (map (
              service: {
                name = "tank0-${service.name}";
                value = {
                  source = "rpool/${service.name}";
                  target = "tank0/backups/${service.name}";
                };
              }
            )
            hostedServices))
        (builtins.listToAttrs
          (map (
              service: {
                name = "tank1-${service.name}";
                value = {
                  source = "rpool/${service.name}";
                  target = "tank1/backups/${service.name}";
                };
              }
            )
            hostedServices))
      ];
    };
  };
}
