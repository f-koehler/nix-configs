{
  pkgs,
  config,
  ...
}: {
  virtualisation.oci-containers.containers = {
    hass = {
      image = "ghcr.io/home-assistant/home-assistant:2024.6.1";
      extraOptions = [
        "--privileged"
        "--network=host"
      ];
      environment = {
        TZ = "Asia/Singapore";
      };
      volumes = [
        "/var/lib/hass:/config"
        "/run/dbus:/run/dbus:ro"
      ];
    };
  };
  # services = {
  #   nginx = {
  #     upstreams."hass" = {
  #       servers = {
  #         "127.0.0.1:${toString config.services.home-assistant.config.http.server_port}" = {};
  #       };
  #     };
  #     virtualHosts."home.fkoehler.xyz" = {
  #       forceSSL = true;
  #       kTLS = true;
  #       sslCertificate = "/var/lib/acme/fkoehler.xyz/fullchain.pem";
  #       sslCertificateKey = "/var/lib/acme/fkoehler.xyz/key.pem";
  #       listen = [
  #         {
  #           addr = "0.0.0.0";
  #           port = 443;
  #           ssl = true;
  #         }
  #       ];
  #       locations = {
  #         "/" = {
  #           proxyPass = "http://hass";
  #           extraConfig = ''
  #             proxy_http_version 1.1;
  #             proxy_buffering off;
  #             proxy_redirect http:// https://;
  #             proxy_set_header Upgrade $http_upgrade;
  #             proxy_set_header Connection "upgrade";
  #             proxy_set_header Host $host;
  #             proxy_set_header X-Real-IP $remote_addr;
  #             proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  #             proxy_set_header X-Forwarded-Host $server_name;
  #             add_header Referrer-Policy "strict-origin-when-cross-origin";
  #           '';
  #         };
  #       };
  #     };
  #   };
  # };
}
