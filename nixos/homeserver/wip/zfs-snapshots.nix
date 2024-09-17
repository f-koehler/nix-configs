{lib, ...}: let
  hostedServices = [
    {
      name = "gickup";
      dense = true;
    }
    # {
    #   name = "paperless";
    #   units = ["paperless-web" "paperless-consumer" "paperless-scheduler" "paperless-task-queue"];
    #   dense = true;
    # }
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
  systemd.services =
    builtins.listToAttrs (lib.flatten (map (service: let
      units =
        if (builtins.hasAttr "units" service)
        then service.units
        else ["${service.name}"];
    in
      map (unit: {
        name = "${unit}";
        value = {
          after = ["var-lib-${service.name}.mount"];
          wants = ["var-lib-${service.name}.mount"];
        };
      })
      units)
    hostedServices))
    // builtins.listToAttrs (lib.flatten (map (pool: (map (service: {
        name = "syncoid-${pool}-${service.name}.service";
        value = {
          wants = ["var-lib-${service.name}.mount" "zfs-import-${pool}.service"];
          after = ["var-lib-${service.name}.mount" "zfs-import-${pool}.service"];
        };
      })
      hostedServices)) ["tank0" "tank1"]));
  services = {
    sanoid = {
      enable = true;
      datasets = builtins.listToAttrs (lib.flatten (map (pool: (map (service: let
          template =
            if (builtins.hasAttr "dense" service) && service.dense
            then "dense"
            else "sparse";
          autosnap = pool == "rpool";
          poolPath =
            if pool == "rpool"
            then "rpool"
            else "${pool}/backups";
        in {
          name = "${poolPath}/${service.name}";
          value = {
            inherit autosnap;
            useTemplate = [template];
          };
        })
        hostedServices)) ["rpool" "tank0" "tank1"]));
      templates = {
        dense = {
          autoprune = true;
          yearly = 10;
          monthly = 24;
          daily = 60;
          hourly = 96;
        };
        sparse = {
          autoprune = true;
          yearly = 1;
          monthly = 12;
          daily = 21;
          hourly = 96;
        };
      };
    };
    syncoid = {
      enable = true;
      commonArgs = ["--no-sync-snap"];
      commands = builtins.listToAttrs (lib.flatten (map (pool: (map (service: {
          name = "${pool}-${service.name}";
          value = {
            source = "rpool/${service.name}";
            target = "${pool}/backups/${service.name}";
          };
        })
        hostedServices)) ["tank0" "tank1"]));
    };
  };
}
