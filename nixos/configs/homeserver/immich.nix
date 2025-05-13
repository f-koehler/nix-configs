{
  config,
  nodeConfig,
  stateVersion,
  ...
}:
let
  port = 2283;
in
{
  # TODO(fk): implement DB backup:
  # - create DB backups with something like: `sudo -u immich -g immich pg_dump -d immich | gzip -9 > immich.psql.gz`
  # - trigger via pre-command of sanoid (probably have to implement by modifying systemd service
  containers.immich = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "172.22.1.1";
    localAddress = "172.22.1.100";
    allowedDevices = [
      {
        modifier = "rwm";
        node = "/dev/dri/renderD128";
      }
    ];
    bindMounts = {
      "/nextcloud-photos" = {
        hostPath = "/var/lib/nextcloud/data/fkoehler/files/Photos";
        isReadOnly = true;
      };
    };
    config = _: {
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
    };
  };
  services.nginx = {
    upstreams."immich" = {
      servers = {
        "172.22.1.100:${toString port}" = { };
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
}
