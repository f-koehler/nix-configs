{ pkgs, ... }:
let
  port = 33133;
in
{
  services = {
    forgejo = {
      enable = true;
      package = pkgs.forgejo;
      database.type = "postgres";
      settings = {
        server = rec {
          HTTP_PORT = port;
          PROTOCOL = "http";
          DOMAIN = "git.fkoehler.xyz";
          ROOT_URL = "https://${DOMAIN}/";
        };
      };
    };
    nginx = {
      upstreams."forgejo" = {
        servers = {
          "127.0.0.1:${toString port}" = { };
        };
      };
      virtualHosts."git.fkoehler.xyz" = {
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
            proxyPass = "http://forgejo/";
            extraConfig = ''
              proxy_http_version 1.1;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";

              proxy_redirect off;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Host $server_name;
              add_header Referrer-Policy "strict-origin-when-cross-origin";

              client_max_body_size 1024M;
            '';
          };
        };
      };
    };
  };

  fileSystems = {
    "/var/lib/forgejo" = {
      device = "rpool/forgejo";
      fsType = "zfs";
      neededForBoot = true;
    };
  };
}
