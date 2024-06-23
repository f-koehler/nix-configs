{config, ...}: {
  sops.secrets = {
    "services/pgadmin/password" = {};
  };
  services = {
    pgadmin = {
      enable = true;
      initialEmail = "fabian.koehler@proton.me";
      initialPasswordFile = config.sops.secrets."services/pgadmin/password".path;
    };
  };
  services.nginx = {
    upstreams.pgadmin = {
      servers = {
        "127.0.0.1:5050" = {};
      };
    };
    virtualHosts."pgadmin.fkoehler.xyz" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/var/lib/acme/fkoehler.xyz/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/fkoehler.xyz/key.pem";
      http2 = true;
      listen = [
        {
          addr = "0.0.0.0";
          port = 443;
          ssl = true;
        }
      ];
      locations = {
        "/" = {
          proxyPass = "http://pgadmin/";
          extraConfig = ''
            proxy_set_header   X-Real-IP $remote_addr;
            proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header   Host $host;
            proxy_http_version 1.1;
            proxy_set_header   Upgrade $http_upgrade;
            proxy_set_header   Connection "upgrade";
          '';
        };
      };
    };
  };
}
