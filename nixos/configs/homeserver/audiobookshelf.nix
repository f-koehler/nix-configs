{
  config,
  stateVersion,
  nodeConfig,
  ...
}:
let
  ip = "172.22.1.102";
  inherit (config.services.audiobookshelf) port;
in
{
  containers.audiobookshelf = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "172.22.1.1";
    localAddress = ip;
    bindMounts = {
      "/etc/resolv.conf" = {
        hostPath = "/etc/resolv.conf";
        isReadOnly = true;
      };
      "/var/lib/audiobookshelf" = {
        hostPath = "/containers/audiobookshelf/app";
        isReadOnly = false;
      };
      "/audiobooks" = {
        hostPath = "/media/tank1/media/audiobooks";
        isReadOnly = false;
      };
      "/audiobooks_perry_rhodan" = {
        hostPath = "/media/tank1/media/audiobooks_perry_rhodan";
        isReadOnly = false;
      };
      "/podcasts" = {
        hostPath = "/media/tank0/media/podcasts";
        isReadOnly = false;
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
        audiobookshelf = {
          enable = true;
          host = "0.0.0.0";
          inherit port;
        };
      };
    };
  };
  services = {
    nginx = {
      upstreams."audiobookshelf" = {
        servers = {
          "${ip}:${toString config.services.audiobookshelf.port}" = { };
        };
      };
      virtualHosts."audiobooks.fkoehler.xyz" = {
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
            proxyPass = "http://audiobookshelf/";
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
}
