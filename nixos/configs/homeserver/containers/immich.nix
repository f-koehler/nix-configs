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
  inherit (config.services.immich) port;
  ip = "172.22.1.100";
  containerName = "immich";
  hostName = "photos";
  domain = "corgi-dojo.ts.net";
in
{
  sops.secrets = {
    "services/tailscale/authKey" = {
    };
  };
  containers.immich =
    let
      hostConfig = config;
    in
    {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "172.22.1.1";
      localAddress = ip;
      additionalCapabilities = [
        "CAP_NET_ADMIN"
        "CAP_NET_RAW"
        "CAP_MKNOD"
      ];
      allowedDevices = [
        {
          modifier = "rwm";
          node = "/dev/dri/renderD128";
        }
        {
          node = "/dev/net/tun";
          modifier = "rwm";
        }
      ];
      bindMounts = {
        "/nextcloud-photos" = {
          hostPath = "/containers/nextcloud/data/fkoehler/files/Photos";
          isReadOnly = true;
        };
        "/db_backup" = {
          hostPath = "/containers/${containerName}/db_backup";
          isReadOnly = false;
        };
        "${hostConfig.sops.secrets."services/tailscale/authKey".path}".isReadOnly = true;
      };
      config =
        _:
        let
          run-cmd-with-lock = inputs.run-cmd-with-lock.packages.${nodeConfig.system}.default;
          script-db-dump = pkgs.writeShellScriptBin "${containerName}-backup-db" ''
            #!${lib.getExe' pkgs.bash "bash"}
            set -euf -o pipefail
            /run/current-system/sw/bin/pg_dump -d immich | /run/current-system/sw/bin/gzip -9 > /db_backup/immich.psql.gz
          '';
          script-tailscale-serve =
            let
              tailscale = lib.getExe' pkgs.tailscale "tailscale";
              jq = lib.getExe' pkgs.jq "jq";
            in
            pkgs.writeShellScriptBin "${containerName}-tailscale-serve" ''
              #!${lib.getExe' pkgs.bash "bash"}
              set -euf -o pipefail

              while [[ "$(${tailscale} status --json --peers=false | ${jq} -r '.BackendState')" == "NoState" ]]; do
                sleep 0.5
              done
              ${tailscale} serve ${toString port}
            '';
        in
        {
          system.stateVersion = stateVersion;
          boot.isContainer = true;
          time.timeZone = nodeConfig.timeZone;
          networking = {
            hostName = containerName;
            inherit domain;
            firewall = {
              enable = true;
              allowedTCPPorts = [
                port
                443
              ];
            };
          };
          services = {
            tailscale = {
              enable = true;
              authKeyFile = hostConfig.sops.secrets."services/tailscale/authKey".path;
              openFirewall = true;
              interfaceName = hostName;
              extraUpFlags = [
                "--hostname=${hostName}"
                "--operator=tailscale"
              ];
            };
            immich = {
              enable = true;
              host = "0.0.0.0";
              inherit port;
              accelerationDevices = [ "/dev/dri/renderD128" ];
            };
            nginx = {
              enable = true;
              upstreams."${hostName}" = {
                servers = {
                  "0.0.0.0:${toString port}" = { };
                };
              };
              virtualHosts."${hostName}.${domain}" = {
                listen = [
                  {
                    addr = "0.0.0.0";
                    port = 80;
                  }
                ];
                locations = {
                  "/" = {
                    proxyPass = "http://${hostName}/";
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
          };
          users = {
            groups.tailscale = { };
            users.tailscale = {
              isSystemUser = true;
              group = "tailscale";
            };
          };
          systemd = {
            services = {
              tailscaled-autoconnect.serviceConfig.Type = lib.mkForce "exec";
              tailscale-serve = {
                enable = true;
                description = "Tailscale Serve";
                requires = [
                  "tailscaled.service"
                  "tailscaled-autoconnect.service"
                ];
                after = [
                  "tailscaled.service"
                  "tailscaled-autoconnect.service"
                ];
                wantedBy = [ "multi-user.target" ];
                serviceConfig = {
                  Type = "exec";
                  ExecStart = "${lib.getExe script-tailscale-serve}";
                  User = "tailscale";
                  Group = "tailscale";
                };
              };
              "backup-${containerName}" = {
                description = "Create a backup of immich";
                serviceConfig = {
                  Type = "oneshot";
                  User = config.services.immich.user;
                  Group = config.services.immich.group;
                  ExecStart = "${lib.getExe run-cmd-with-lock} --lockfile /db_backup/lock --command ${lib.getExe script-db-dump}";
                };
              };
            };
            timers."backup-${containerName}" = {
              description = "Periodic backups of immich";
              timerConfig = {
                Unit = "backup-${containerName}.service";
                OnCalendar = "*-*-* 4:00:00";
              };
            };
          };
        };
    };
  # services = {
  #   nginx = {
  #     upstreams."immich" = {
  #       servers = {
  #         "0.0.0.0:${toString port}" = { };
  #       };
  #     };
  #     virtualHosts."photos.fkoehler.xyz" = {
  #       forceSSL = true;
  #       kTLS = true;
  #       sslCertificate = "/var/lib/acme/fkoehler.xyz/fullchain.pem";
  #       sslCertificateKey = "/var/lib/acme/fkoehler.xyz/key.pem";
  #       listen = [
  #         {
  #           addr = "0.0.0.0";
  #           port = 443;
  #           ssl = true;
  #         }
  #       ];
  #       locations = {
  #         "/" = {
  #           proxyPass = "http://immich/";
  #           extraConfig = ''
  #             proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  #             proxy_set_header X-Forwarded-Proto $scheme;
  #             proxy_set_header Host $host;
  #             proxy_set_header Upgrade $http_upgrade;
  #             proxy_set_header Connection "upgrade";
  #             proxy_http_version 1.1;
  #             proxy_redirect http:// https://;
  #           '';
  #         };
  #       };
  #     };
  #   };
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
  # };
}
