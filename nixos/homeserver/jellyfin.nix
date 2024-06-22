{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];
  users.users.jellyfin.extraGroups = ["media"];
  services = {
    jellyfin = {
      enable = true;
      openFirewall = true;
      user = "jellyfin";
      group = "jellyfin";
    };
    jellyseerr = {
      enable = true;
    };
    nginx = {
      upstreams = {
        jellyfin = {
          servers = {
            "127.0.0.1:8096" = {};
          };
        };
        jellyseerr = {
          servers = {
            "127.0.0.1:${toString config.services.jellyseerr.port}" = {};
          };
        };
      };
      virtualHosts = {
        "media.fkoehler.xyz" = {
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
            "= /" = {
              return = "302 https://$host/web/";
            };
            "/" = {
              proxyPass = "http://jellyfin";
              extraConfig = ''
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
                proxy_set_header X-Forwarded-Protocol $scheme;
                proxy_set_header X-Forwarded-Host $http_host;

                # Disable buffering when the nginx proxy gets very resource heavy upon streaming
                proxy_buffering off;
              '';
            };

            "= /web/" = {
              proxyPass = "http://jellyfin/web/index.html";
              extraConfig = ''
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
                proxy_set_header X-Forwarded-Protocol $scheme;
                proxy_set_header X-Forwarded-Host $http_host;
              '';
            };

            "/socket" = {
              proxyPass = "http://jellyfin";
              extraConfig = ''
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "upgrade";
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
                proxy_set_header X-Forwarded-Protocol $scheme;
                proxy_set_header X-Forwarded-Host $http_host;
              '';
            };
          };
        };
        "wishlist.fkoehler.xyz" = {
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
              proxyPass = "http://jellyseerr/";
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
  };
}
