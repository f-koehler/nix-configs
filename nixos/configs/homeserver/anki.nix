{ config, lib, ... }:
{
  sops.secrets = {
    "services/anki/users/fkoehler/password" = {
      owner = "anki";
      group = "anki";
    };
  };
  services = {
    anki-sync-server = {
      enable = true;
      address = "0.0.0.0";
      baseDirectory = "/var/lib/anki/";
      users = [
        {
          username = "fkoehler";
          passwordFile = config.sops.secrets."services/anki/users/fkoehler/password".path;
        }
      ];
    };
    nginx = {
      upstreams."anki" = {
        servers = {
          "127.0.0.1:${toString config.services.anki-sync-server.port}" = { };
        };
      };
      virtualHosts."anki.fkoehler.xyz" = {
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
            proxyPass = "http://anki/";
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
            '';
          };
        };
      };
    };
  };
  systemd = {
    services.anki-sync-server.serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "anki";
      Group = "anki";
    };
    tmpfiles.settings.beszelHubDirs."/var/lib/anki/".d = {
      mode = "700";
      user = "anki";
      group = "anki";
    };
  };
  users = {
    groups.anki = { };
    users.anki = {
      isSystemUser = true;
      group = "anki";
      home = "/var/lib/anki";
    };
  };
}
