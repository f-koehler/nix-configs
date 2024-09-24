{
  config,
  pkgs,
  ...
}: {
  sops.secrets = {
    "services/paperless/admin/password" = {
      owner = config.services.paperless.user;
      group = config.services.paperless.user;
    };
  };
  services = {
    postgresql = {
      enable = true;
      ensureDatabases = ["paperless"];
      ensureUsers = [
        {
          name = "paperless";
          ensureDBOwnership = true;
        }
      ];
    };
    tika = {
      enable = true;
      enableOcr = true;
    };
    # gotenberg = {
    #   enable = true;
    # };
    paperless = {
      enable = true;
      package = pkgs.paperless-ngx;
      user = "paperless";
      passwordFile = config.sops.secrets."services/paperless/admin/password".path;
      settings = {
        # Database
        PAPERLESS_DBENGINE = "postgresql";
        PAPERLESS_DBHOST = "/run/postgresql";
        PAPERLESS_DBUSER = "paperless";

        # Tika/Gotenberg
        PAPERLESS_TIKA_ENABLED = true;
        PAPERLESS_TIKA_ENDPOINT = "http://localhost:${toString config.services.tika.port}";
        # PAPERLESS_TIKA_GOTENBERG_ENDPOINT = "http://localhost:${toString config.services.gotenberg.port}";

        # Hosting & security
        PAPERLESS_URL = "https://docs.fkoehler.xyz";
        PAPERLESS_ADMIN_USER = "fkoehler";

        # OCR
        PAPERLESS_OCR_LANGUAGE = "deu+eng";
        PAPERLESS_OCR_USER_ARGS = {
          invalidate_digital_signatures = true;
        };

        # Tweaks
        PAPERLESS_TASK_WORKERS = 2;
        PAPERLESS_THREADS_PER_WORKER = 2;
        PAPERLESS_TIME_ZONE = "Asia/Singapore";

        # Document Consumption
        PAPERLESS_CONSUMER_RECURSIVE = true;

        # PAPERLESS_USE_X_FORWARD_HOST = true;
        # PAPERLESS_USE_X_FORWARD_PORT = true;
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

  fileSystems = {
    "/var/lib/paperless" = {
      device = "rpool/paperless";
      fsType = "zfs";
      neededForBoot = true;
    };
  };
}
