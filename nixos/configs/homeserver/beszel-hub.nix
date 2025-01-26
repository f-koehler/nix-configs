{ pkgs, lib, ... }:
let
  port = 8090;
in
{
  environment.systemPackages = [
    pkgs.beszel
  ];
  users = {
    groups.beszel = { };
    users.beszel = {
      home = "/var/lib/beszel";
      homeMode = "700";
      createHome = true;
      isSystemUser = true;
      group = "beszel";
    };
  };
  systemd = {
    tmpfiles.settings.beszelHubDirs."/var/lib/beszel/hub/".d = {
      mode = "700";
      user = "beszel";
      group = "beszel";
    };
    services.beszel-hub = {
      name = "beszel-hub.service";
      description = "Beszel Hub";
      after = [ "network.target" ];
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = "3";
        User = "beszel";
        Group = "beszel";
        WorkingDirectory = "/var/lib/beszel/hub";
        ExecStart = "${lib.getExe' pkgs.beszel "beszel-hub"} serve --http 0.0.0.0:${toString port}";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
  services = {
    nginx = {
      upstreams."beszel" = {
        servers = {
          "127.0.0.1:${toString port}" = { };
        };
      };
      virtualHosts."beszel.fkoehler.xyz" = {
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
            proxyPass = "http://beszel/";
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
