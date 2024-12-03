{config, ...}: let
  port = 40800;
in {
  sops = {
    secrets = {
      "services/searx/secretKey" = {};
    };
    templates."searx.env" = {
      content = ''
        SEARX_SECRET_KEY=${config.sops.placeholder."services/searx/secretKey"}
      '';
      owner = "searx";
      group = "searx";
    };
  };
  services = {
    searx = {
      enable = true;
      settings = {
        server = {
          inherit port;
          bind_address = "0.0.0.0";
          secret_key = "@SEARX_SECRET_KEY@";
        };
      };
    };
    nginx = {
      upstreams."searx" = {
        servers = {
          "127.0.0.1:${toString port}" = {};
        };
      };
      virtualHosts."search.fkoehler.xyz" = {
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
            proxyPass = "http://searx/";
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
