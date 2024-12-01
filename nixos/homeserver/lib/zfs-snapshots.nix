{
  lib,
  config,
  ...
}: let
  cfg = config.homeserver.zfsSnapshots;
  serviceOptions = {
    sanoidTemplate = lib.mkOption {
      type = lib.types.str;
      default = "default";
    };
  };
  services = lib.unique (lib.attrNames cfg.services);
  mkSanoidDataset = {
    name,
    options,
  }: {
    "rpool/${name}" = {
      useTemplate = [options.sanoidTemplate];
      autosnap = true;
      autoprune = true;
    };
  };
  mkSyncoidCommand = {
    name,
    pool,
    ...
  }: {
    "${pool}-${name}" = {
      useCommonArgs = true;
      source = "rpool/${name}";
      target = "${pool}/backups/${name}";
    };
  };
  mkSyncoidDeps = {
    name,
    pool,
    ...
  }: {
    "syncoid-${pool}-${name}.service" = {
      wants = ["var-lib-${name}.mount" "zfs-import-${pool}.service"];
      after = ["var-lib-${name}.mount" "zfs-import-${pool}.service"];
    };
  };
in {
  options.homeserver.zfsSnapshots = {
    enable = lib.mkEnableOption "Automatic ZFS snapshots for hosted services with Sanoid & Syncoid";
    services = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {options = serviceOptions;});
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      sanoid = {
        enable = true;
        templates.default = {
          autoprune = true;
          yearly = 5;
          monthly = 24;
          daily = 90;
          hourly = 120;
        };
        datasets = lib.mkMerge (
          map (service: (mkSanoidDataset {
            name = service;
            options = cfg.services.${service};
          }))
          services
        );
      };
      syncoid = {
        enable = true;
        interval = "daily";
        commonArgs = ["--no-sync-snap"];
        commands = lib.mkMerge (
          (map (service: (mkSyncoidCommand {
              name = service;
              pool = "tank0";
            }))
            services)
          ++ (map (service: (mkSyncoidCommand {
              name = service;
              pool = "tank1";
            }))
            services)
        );
      };
    };
    systemd.services = lib.mkMerge (
      (map (service: (mkSyncoidDeps {
          name = service;
          pool = "tank0";
        }))
        services)
      ++ (map (service: (mkSyncoidDeps {
          name = service;
          pool = "tank1";
        }))
        services)
    );
  };
}
