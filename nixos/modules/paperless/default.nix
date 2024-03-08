{
  config,
  pkgs,
  ...
}: {
  sops.secrets = {
    "services/paperless/secretKey" = {
      owner = config.services.paperless.user;
      group = config.services.paperless.user;
    };
    "services/paperless/admin/password" = {
      owner = config.services.paperless.user;
      group = config.services.paperless.user;
    };
    "services/paperless/admin/email" = {
      owner = config.services.paperless.user;
      group = config.services.paperless.user;
    };
  };
  services = {
    postgresql = {
      enable = true;
      ensureUsers = [
        {
          name = "paperless";
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = ["paperless"];
    };
    paperless = {
      enable = true;
      package = pkgs.paperless-ngx;
      user = "fkoehler";
      passwordFile = config.sops.secrets."services/paperless/admin/password".path;
      port = 8098;
      settings = {
        PAPERLESS_DBENGINE = "postgresql";
        PAPERLESS_TIKA_ENABLED = false; # TODO: install tika and gotenberg as container and enable
        # PAPERLESS_SECRET_KEY = "changeme";
        PAPERLESS_URL = "https://docs.fkoehler.xyz";
        PAPERLESS_ADMIN_USER = "fkoehler";
        PAPERLESS_OCR_LANGUAGE = "deu+eng";
        PAPERLESS_TASK_WORKERS = 4;
        PAPERLESS_TIME_ZONE = "Asia/Singapore";
        PAPERLESS_USE_X_FORWARD_HOST = true;
        PAPERLESS_USE_X_FORWARD_PORT = true;
      };
    };
    nginx = {
      upstreams."paperless" = {
        servers = {
          "127.0.0.1:${toString config.services.paperless.port}" = {};
        };
      };
      virtualHosts."docs.fkoehler.xyz" = {
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
            proxyPass = "http://paperless/";
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
}
