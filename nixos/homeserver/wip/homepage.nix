{config, ...}: {
  sops = {
    secrets = {
      "services/homepage/audiobookshelf_api_key" = {};
      "services/homepage/jellyseerr_api_key" = {};
      "services/homepage/jellyfin_api_key" = {};
      "services/homepage/nextcloud_api_key" = {};
      "services/homepage/paperless_api_key" = {};
      "services/homepage/sonarr_api_key" = {};
      "services/homepage/radarr_api_key" = {};
      "services/homepage/prowlarr_api_key" = {};
    };
    templates."homepage-dashboard.env" = {
      content = ''
        HOMEPAGE_VAR_AUDIOBOOKSHELF_API_KEY=${config.sops.placeholder."services/homepage/audiobookshelf_api_key"}
        HOMEPAGE_VAR_JELLYSEERR_API_KEY=${config.sops.placeholder."services/homepage/jellyseerr_api_key"}
        HOMEPAGE_VAR_JELLYFIN_API_KEY=${config.sops.placeholder."services/homepage/jellyfin_api_key"}
        HOMEPAGE_VAR_NEXTCLOUD_API_KEY=${config.sops.placeholder."services/homepage/nextcloud_api_key"}
        HOMEPAGE_VAR_PAPERLESS_API_KEY=${config.sops.placeholder."services/homepage/paperless_api_key"}
        HOMEPAGE_VAR_SONARR_API_KEY=${config.sops.placeholder."services/homepage/sonarr_api_key"}
        HOMEPAGE_VAR_RADARR_API_KEY=${config.sops.placeholder."services/homepage/radarr_api_key"}
        HOMEPAGE_VAR_PROWLARR_API_KEY=${config.sops.placeholder."services/homepage/prowlarr_api_key"}
      '';
    };
  };
  services.homepage-dashboard = {
    enable = true;
    environmentFile = "${config.sops.templates."homepage-dashboard.env".path}";
    widgets = [
      {
        search = {
          provider = "google";
          focus = true;
          showSearchSuggestions = true;
          target = "_blank";
        };
      }
      {
        resources = {
          cpu = true;
          memory = true;
          cputemp = true;
          tempmin = 0;
          tempmax = 100;
          units = "metric";
        };
      }
    ];
    services = let
      audiobookshelf_url = "https://audiobooks.fkoehler.xyz";
      jellyseerr_url = "https://wishlist.fkoehler.xyz";
      jellyfin_url = "https://media.fkoehler.xyz";
      nextcloud_url = "https://cloud.fkoehler.xyz";
      paperless_url = "https://docs.fkoehler.xyz";
      pgadmin_url = "https://pgadmin.fkoehler.xyz";
      tinymediamanager_url = "https://tinymediamanager.fkoehler.xyz";
      uptime_kuma_url = "https://uptime.fkoehler.xyz";
      sonarr_url = "http://100.117.111.97:8989";
      radarr_url = "http://100.117.111.97:7878";
      prowlarr_url = "http://100.117.111.97:9696";
      transmission_url = "http://100.117.111.97:9091";
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
            "Jellyseer" = {
              icon = "jellyseerr.svg";
              href = jellyseerr_url;
              description = "Media wishlist";
              widget = {
                type = "jellyseerr";
                url = jellyseerr_url;
                key = "{{HOMEPAGE_VAR_JELLYSEERR_API_KEY}}";
              };
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
          {
            "pgadmin" = {
              icon = "pgadmin.svg";
              href = pgadmin_url;
              description = "Manage Postgres SQL";
            };
          }
        ];
      }
      {
        "Media Management" = [
          {
            "tinyMediaManager" = {
              href = tinymediamanager_url;
              description = "Manage media";
            };
          }
          {
            "Sonarr" = {
              icon = "sonarr.svg";
              href = sonarr_url;
              description = "Recorder for TV Shows";
              widget = {
                type = "sonarr";
                url = sonarr_url;
                key = "{{HOMEPAGE_VAR_SONARR_API_KEY}}";
              };
            };
          }
          {
            "Radarr" = {
              icon = "radarr.svg";
              href = radarr_url;
              description = "Recorder for Movies";
              widget = {
                type = "radarr";
                url = radarr_url;
                key = "{{HOMEPAGE_VAR_RADARR_API_KEY}}";
              };
            };
          }
          {
            "Prowlarr" = {
              icon = "prowlarr.svg";
              href = prowlarr_url;
              description = "Indexer for Sonarr & Radarr";
              widget = {
                type = "prowlarr";
                url = prowlarr_url;
                key = "{{HOMEPAGE_VAR_PROWLARR_API_KEY}}";
              };
            };
          }
        ];
      }
      {
        "Netdata" = [
          {
            "homeserver" = {
              icon = "netdata.svg";
              href = "http://homeserver.corgi-dojo.ts.net:19999";
              description = "Monitoring for homeserver";
              widget = {
                type = "netdata";
                url = "http://homeserver.corgi-dojo.ts.net:19999";
              };
            };
          }
          {
            "downloader" = {
              icon = "netdata.svg";
              href = "http://downloader.corgi-dojo.ts.net:19999";
              description = "Monitoring for downloader";
              widget = {
                type = "netdata";
                url = "http://downloader.corgi-dojo.ts.net:19999";
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
