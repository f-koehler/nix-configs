{
  pkgs,
  config,
  stateVersion,
  nodeConfig,
  ...
}:
let
  ip = "172.22.1.104";
in
{
  sops.secrets = {
    "services/nextcloud/admin/password" = {
      owner = "nextcloud";
      group = "nextcloud";
    };
  };
  services = {
    nginx = {
      upstreams."nextcloud" = {
        servers = {
          "${ip}:80" = { };
        };
      };
      virtualHosts = {
        "cloud.fkoehler.xyz" = {
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
              proxyPass = "http://nextcloud/";
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
  };

  containers.nextcloud =
    let
      hostConfig = config;
    in
    {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "172.22.1.1";
      localAddress = ip;
      bindMounts = {
        "/var/lib/nextcloud/data" = {
          hostPath = "/containers/nextcloud/data";
          isReadOnly = false;
        };
        "/backup/db" = {
          hostPath = "/containers/nextcloud/db_backup";
          isReadOnly = false;
        };
        "${hostConfig.sops.secrets."services/nextcloud/admin/password".path}".isReadOnly = true;
      };
      config = {
        system.stateVersion = stateVersion;
        boot.isContainer = true;
        time.timeZone = nodeConfig.timeZone;
        networking.firewall = {
          enable = true;
          allowedTCPPorts = [ 80 ];
        };
        services = {
          nextcloud = rec {
            enable = true;
            package = pkgs.nextcloud31;
            hostName = "cloud.fkoehler.xyz";
            https = true;
            enableImagemagick = true;
            configureRedis = true;
            config = {
              dbtype = "pgsql";
              adminuser = "fkoehler";
              adminpassFile = hostConfig.sops.secrets."services/nextcloud/admin/password".path;
            };
            phpOptions."opcache.interned_strings_buffer" = "32";
            caching.redis = true;
            database.createLocally = true;
            maxUploadSize = "20G";
            settings = {
              default_phone_region = "SG";
              maintenance_window_start = 0;
            };
            autoUpdateApps.enable = true;
            extraAppsEnable = true;
            extraApps = with package.packages.apps; {
              inherit contacts tasks calendar;
            };
          };
        };
      };
    };
}
