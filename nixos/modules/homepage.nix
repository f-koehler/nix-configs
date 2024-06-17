{config, ...}: {
  sops = {
    secrets = {
      "services/homepage/audiobookshelf_api_key" = {};
      "services/homepage/jellyfin_api_key" = {};
      "services/homepage/nextcloud_api_key" = {};
      "services/homepage/paperless_api_key" = {};
    };
    templates."homepage-dashboard.env" = {
      content = ''
        HOMEPAGE_VAR_AUDIOBOOKSHELF_API_KEY=${config.sops.placeholder."services/homepage/audiobookshelf_api_key"}
        HOMEPAGE_VAR_JELLYFIN_API_KEY=${config.sops.placeholder."services/homepage/jellyfin_api_key"}
        HOMEPAGE_VAR_NEXTCLOUD_API_KEY=${config.sops.placeholder."services/homepage/nextcloud_api_key"}
        HOMEPAGE_VAR_PAPERLESS_API_KEY=${config.sops.placeholder."services/homepage/paperless_api_key"}
      '';
    };
  };
  services.homepage-dashboard = {
    enable = true;
    environmentFile = "${config.sops.templates."homepage-dashboard.env".path}";
    services = let
      audiobookshelf_url = "https://audiobooks.fkoehler.xyz";
      jellyfin_url = "https://media.fkoehler.xyz";
      nextcloud_url = "https://cloud.fkoehler.xyz";
      paperless_url = "https://docs.fkoehler.xyz";
      tinymediamanager_url = "https://tinymediamanager.fkoehler.xyz";
      transmission_url = "http://100.117.111.97:9091";
      uptime_kuma_url = "https://uptime.fkoehler.xyz";
    in [
      {
        "Media" = [
          {
            "Jellyfin" = {
              icon = "jellyfin.svg";
              href = jellyfin_url;
              description = "Movies, TV Shows and Music";
              widget = {
                type = "jellyfin";
                url = jellyfin_url;
                key = "{{HOMEPAGE_VAR_JELLYFIN_API_KEY}}";
              };
            };
          }
          {
            "Audiobookshelf" = {
              icon = "audiobookshelf.svg";
              href = audiobookshelf_url;
              description = "Audiobooks";
              widget = {
                type = "audiobookshelf";
                url = audiobookshelf_url;
                key = "{{HOMEPAGE_VAR_AUDIOBOOKSHELF_API_KEY}}";
              };
            };
          }
          {
            "tinyMediaManager" = {
              href = tinymediamanager_url;
              description = "Manage media";
            };
          }
        ];
      }
      {
        "Productivity" = [
          {
            "Nextcloud" = {
            icon = "nextcloud.svg";
              href = nextcloud_url;
              description = "Personal cloud";
              widget = {
                type = "nextcloud";
                url = nextcloud_url;
                key = "{{HOMEPAGE_VAR_NEXTCLOUD_API_KEY}}";
              };
            };
          }
          {
            "Paperless" = {
              icon = "paperless-ngx.svg";
              href = paperless_url;
              description = "Documents";
              widget = {
                type = "paperlessngx";
                url = paperless_url;
                key = "{{HOMEPAGE_VAR_PAPERLESS_API_KEY}}";
              };
            };
          }
        ];
      }
      {
        "Misc" = [
          {
            "Transmission" = {
              icon = "transmission.svg";
              href = transmission_url;
              description = "Downloads";
              widget = {
                type = "transmission";
                url = transmission_url;
              };
            };
          }
          {
            "Uptime Kuma" = {
              icon = "uptime-kuma.svg";
              href = uptime_kuma_url;
              description = "Service uptimes";
              widget = {
                type = "uptimekuma";
                url = uptime_kuma_url;
                slug = "homeserver";
              };
            };
          }
        ];
      }
    ];
  };
  services.nginx = {
    upstreams.homepage = {
      servers = {
        "127.0.0.1:8082" = {};
      };
    };
    virtualHosts."homepage.fkoehler.xyz" = {
      default = true;
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
          proxyPass = "http://homepage/";
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
