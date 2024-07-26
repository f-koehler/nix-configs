{config, ...}: let
  port = 8097;
in {
  containers.audiobookshelf = {
    ephemeral = true;
    autoStart = true;
    forwardPorts = [
      {
        hostPort = port;
        containerPort = port;
      }
    ];
    bindMounts = {
      "/var/lib/audiobookshelf" = {
        hostPath = "/containers/audiobookshelf/app";
        isReadOnly = false;
      };
    };
    config = _: {
      services.audiobookshelf = {
        inherit port;
        enable = true;
        host = "0.0.0.0";
        user = "audiobookshelf";
        group = "audiobookshelf";
      };
    };
  };
  fileSystems = {
    "/containers/audiobookshelf/app" = {
      device = "rpool/audiobookshelf";
      fsType = "zfs";
    };
  };

  services = {
    nginx = {
      upstreams."audiobookshelf" = {
        servers = {
          "127.0.0.1:${toString port}" = {};
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
