{
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

  script-dump-db = pkgs.writeShellScriptBin "immich-dump-db" ''
    #!${lib.getExe' pkgs.bash "bash"}
    set -euf -o pipefail
    ${lib.getExe' pkgs.sudo "sudo"} -u ${config.services.immich.user} -g ${config.services.immich.group} ${lib.getExe' pkgs.bash "bash"} -c "${lib.getExe' config.services.postgresql.package "pg_dump"} --dbname=${config.services.immich.database.name} --compress=gzip:level=9 --file=/db_backup/immich.psql.gz"
  '';
  script-pre-backup = pkgs.writeShellScriptBin "${containerName}-pre-backup" ''
    #!${lib.getExe' pkgs.bash "bash"}
    set -euf -o pipefail
    ${lib.getExe' pkgs.openssh "ssh"} -o StrictHostKeyChecking=accept-new root@${ip} "${lib.getExe script-dump-db}"
  '';
in
{
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
              inherit (hostConfig.services.immich) user group;
              database = { inherit (hostConfig.services.immich.database) name; };
              accelerationDevices = [ "/dev/dri/renderD128" ];
            };
            openssh = {
              enable = true;
              openFirewall = true;
              listenAddresses = [ { addr = ip; } ];
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
            users = {
              tailscale = {
                isSystemUser = true;
                group = "tailscale";
              };
              root.openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJZhXkUJt62fOgcIyrjgFEzOEk34Q0fswDWc//ZMqbWV sanoid@homeserver"
              ];
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
            };
          };
        };
    };
  services = {
    sanoid = {
      datasets."rpool/containers/immich/db_backup" = {
        yearly = 2;
        monthly = 24;
        daily = 90;
        hourly = 96;
        autosnap = true;
        autoprune = true;
        pre_snapshot_script = "${lib.getExe script-pre-backup}";
        no_inconsistent_snapshot = true;
        script_timeout = 0;
      };
    };
  };
}
