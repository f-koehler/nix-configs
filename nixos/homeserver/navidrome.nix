_: let
  port = 4533;
in {
  containers.navidrome = {
    ephemeral = true;
    autoStart = true;

    bindMounts = {
      "/tank0" = {
        hostPath = "/media/tank0/media/";
        isReadOnly = true;
      };
      "/tank1" = {
        hostPath = "/media/tank1/media/";
        isReadOnly = true;
      };
      "/data" = {
        hostPath = "/containers/navidrome/";
        isReadOnly = false;
      };
    };
    config = {lib, ...}: {
      services = {
        navidrome = {
          enable = true;
          settings = {
            Port = port;
            Address = "0.0.0.0";
            MusicFolder = "/tank1/soundtracks";
            DataFolder = "/data";
            BaseUrl = "https://music.fkoehler.xyz";
          };
        };
        resolved.enable = true;
      };
      networking.useHostResolvConf = lib.mkForce false;
    };
  };
  fileSystems = {
    "/containers/navidrome" = {
      device = "rpool/navidrome";
      fsType = "zfs";
    };
  };

  services = {
    nginx = {
      upstreams."navidrome" = {
        servers = {
          "127.0.0.1:${toString port}" = {};
        };
      };
      virtualHosts."music.fkoehler.xyz" = {
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
            proxyPass = "http://navidrome/";
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
