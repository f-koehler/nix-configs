{
  config,
  lib,
  ...
}:
{
  users = {
    groups.uptime-kuma = { };
    users.uptime-kuma = {
      group = "uptime-kuma";
      isSystemUser = true;
    };
  };
  systemd.services.uptime-kuma.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = lib.mkForce "uptime-kuma";
    Group = lib.mkForce "uptime-kuma";
  };
  services = {
    uptime-kuma = {
      enable = true;
      appriseSupport = true;
      settings = {
        PORT = "3001";
      };
    };
    nginx = {
      upstreams."uptime-kuma" = {
        servers = {
          "127.0.0.1:${toString config.services.uptime-kuma.settings.PORT}" = { };
        };
      };
      virtualHosts."uptime.fkoehler.xyz" = {
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
            proxyPass = "http://uptime-kuma/";
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
  };
}
