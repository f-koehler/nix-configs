{
  inputs,
  config,
  nodeConfig,
  stateVersion,
  lib,
  pkgs,
  ...
}:
let
  ip = "172.22.1.100";
  inherit (config.services.immich) port;

in
{
  containers.immich = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "172.22.1.1";
    localAddress = ip;
    allowedDevices = [
      {
        modifier = "rwm";
        node = "/dev/dri/renderD128";
      }
    ];
    bindMounts = {
      "/nextcloud-photos" = {
        hostPath = "/containers/nextcloud/data/fkoehler/files/Photos";
        isReadOnly = true;
      };
      "/db_backup" = {
        hostPath = "/containers/immich/db_backup";
        isReadOnly = false;
      };
    };
    config =
      _:
      let
        run-cmd-with-lock = inputs.run-cmd-with-lock.packages.${nodeConfig.system}.default;
        script-db-dump = pkgs.writeShellScriptBin "immich-backup-db" ''
          /run/current-system/sw/bin/pg_dump -d immich | /run/current-system/sw/bin/gzip -9 > /db_backup/immich.psql.gz
        '';
      in
      {
        system.stateVersion = stateVersion;
        boot.isContainer = true;
        time.timeZone = nodeConfig.timeZone;
        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [ port ];
          };
        };
        services = {
          immich = {
            enable = true;
            host = "0.0.0.0";
            inherit port;
            accelerationDevices = [ "/dev/dri/renderD128" ];
          };
        };
        systemd = {
          services."backup-immich" = {
            description = "Create a backup of immich";
            serviceConfig = {
              Type = "oneshot";
              User = config.services.immich.user;
              Group = config.services.immich.group;
              ExecStart = "${lib.getExe run-cmd-with-lock} --lockfile /db_backup/lock --command ${lib.getExe script-db-dump}";
            };
          };
          timers."backup-immich" = {
            description = "Periodic backups of immich";
            timerConfig = {
              Unit = "backup-immich.service";
              OnCalendar = "*-*-* 4:00:00";
            };
          };
        };
      };
  };
  services = {
    nginx = {
      upstreams."immich" = {
        servers = {
          "${ip}:${toString port}" = { };
        };
      };
      virtualHosts."photos.fkoehler.xyz" = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = "/var/lib/acme/fkoehler.xyz/fullchain.pem";
        sslCertificateKey = "/var/lib/acme/fkoehler.xyz/key.pem";
        listen = [
          {
            addr = "0.0.0.0";
            port = 443;
            ssl = true;
          }
        ];
        locations = {
          "/" = {
            proxyPass = "http://immich/";
            extraConfig = ''
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header Host $host;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";
              proxy_http_version 1.1;
              proxy_redirect http:// https://;
            '';
          };
        };
      };
    };
    # sanoid = {
    #   enable = true;
    #   datasets."rpool/containers/immich" = {
    #     yearly = 2;
    #     monthly = 24;
    #     daily = 90;
    #     hourly = 96;
    #     autosnap = true;
    #     autoprune = true;
    #     # pre_snapshot_script = "${lib.getExe backupScript}";
    #     # no_inconsistent_snapshot = true;
    #     # post_sna
    #     # script_timeout = 0;
    #     recursive = true;
    #   };
    # };
  };
}
