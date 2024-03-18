{
  pkgs,
  config,
  ...
}: {
  services = {
    home-assistant = {
      package =
        (pkgs.home-assistant.override {
          extraPackages = py: with py; [psycopg2];
        })
        .overrideAttrs (oldAttrs: {
          doInstallCheck = false;
        });
      enable = true;
      config = {
        home-assistant = {
          unit_system = "metric";
          time_zone = "Asia/Singapore";
          temperature_unit = "C";
          longitude = 103.79852573812971;
          latitute = 1.311684998498273;
        };
        recorder.db_url = "postgresql://@/hass";
      };
      extraComponents = [
        "default_config"
        "met"
        "esphome"
        "homekit"
        "homekit_controller"
        "homeassistant"
      ];
    };
    postgresql = {
      enable = true;
      ensureDatabases = ["hass"];
      ensureUsers = [
        {
          name = "hass";
          ensureDBOwnership = true;
        }
      ];
    };
    nginx = {
      upstreams."hass" = {
        servers = {
          "127.0.0.1:${toString config.services.home-assistant.config.http.server_port}" = {};
        };
      };
      virtualHosts."home.fkoehler.xyz" = {
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
            proxyPass = "http://hass";
            extraConfig = ''
              proxy_http_version 1.1;
              proxy_buffering off;
              proxy_redirect http:// https://;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";
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
