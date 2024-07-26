{config, ...}: {
  containers.audiobookshelf = {
    bindMounts = {
      "/var/lib/audiobookshelf" = {
        hostPath = "/var/lib/audiobookshelf";
        isReadOnly = false;
      };
    };
    config = _: {
      services.audiobookshelf = {
        enable = true;
        host = "0.0.0.0";
        port = 8097;
        user = "audiobookshelf";
        group = "audiobookshelf";
      };
    };
  };
  # services = {
  #   nginx = {
  #     upstreams."audiobookshelf" = {
  #       servers = {
  #         "127.0.0.1:${toString config.services.audiobookshelf.port}" = {};
  #       };
  #     };
  #     virtualHosts."audiobooks.fkoehler.xyz" = {
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
  #           proxyPass = "http://audiobookshelf/";
  #           extraConfig = ''
  #             proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  #             proxy_set_header X-Forwarded-Proto $scheme;
  #             proxy_set_header Host $host;
  #             proxy_set_header Upgrade $http_upgrade;
  #             proxy_set_header Connection "upgrade";
  #             proxy_http_version 1.1;
  #             proxy_redirect http:// https://;
  #           '';
  #         };
  #       };
  #     };
  #   };
  # };
}
