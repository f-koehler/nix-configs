{config, ...}: {
  services = {
    immich = {
      enable = false;
      host = "127.0.0.1";
      redis.enable = true;
      database = {
        enable = true;
        createDB = true;
        port = 55432;
      };
      machine-learning.enable = true;
    };
    nginx = {
      upstreams."immich" = {
        servers = {
          "127.0.0.1:${toString config.services.immich.port}" = {};
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
              proxy_http_version 1.1;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";

              proxy_redirect off;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Host $server_name;
              add_header Referrer-Policy "strict-origin-when-cross-origin";

              proxy_read_timeout 600s;
              proxy_send_timeout 600s;
              send_timeout       600s;

              client_max_body_size 50000M;
            '';
          };
        };
      };
    };
  };
  users.users.immich.extraGroups = ["nextcloud"];
}
