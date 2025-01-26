{ config, ... }:
let
  port = 8082;
in
{
  sops = {
    secrets = {
      "services/audiobookshelf/apiKey" = { };
      "services/jellyfin/apiKey" = { };
      "services/navidrome/apiKey" = { };
      "services/navidrome/salt" = { };
      "services/nextcloud/apiKey" = { };
      "services/paperless/apiKey" = { };
      "services/forgejo/apiKey" = { };
    };
    templates."homepage-dashboard.env" = {
      content = ''
        HOMEPAGE_VAR_AUDIOBOOKSHELF_API_KEY=${config.sops.placeholder."services/audiobookshelf/apiKey"}
        HOMEPAGE_VAR_JELLYFIN_API_KEY=${config.sops.placeholder."services/jellyfin/apiKey"}
        HOMEPAGE_VAR_NAVIDROME_API_KEY=${config.sops.placeholder."services/navidrome/apiKey"}
        HOMEPAGE_VAR_NAVIDROME_SALT=${config.sops.placeholder."services/navidrome/salt"}
        HOMEPAGE_VAR_NEXTCLOUD_API_KEY=${config.sops.placeholder."services/nextcloud/apiKey"}
        HOMEPAGE_VAR_PAPERLESS_API_KEY=${config.sops.placeholder."services/paperless/apiKey"}
        HOMEPAGE_VAR_FORGEJO_API_KEY=${config.sops.placeholder."services/forgejo/apiKey"}
      '';
    };
  };
  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;
    listenPort = port;
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
    services =
      let
        audiobookshelfUrl = "https://audiobooks.fkoehler.xyz";
        jellyfinUrl = "https://media.fkoehler.xyz";
        navidromeUrl = "https://music.fkoehler.xyz";
        nextcloudUrl = "https://cloud.fkoehler.xyz";
        paperlessUrl = "https://docs.fkoehler.xyz";
        tinymediamanagerUrl = "https://tinymediamanager.fkoehler.xyz";
        invidiousUrl = "https://youtube.fkoehler.xyz";
        forgejoUrl = "https://git.fkoehler.xyz";
      in
      [
        {
          "Media" = [
            {
              "Jellyfin" = {
                icon = "jellyfin.svg";
                href = jellyfinUrl;
                description = "Movies, TV Shows and Music";
                widget = {
                  type = "jellyfin";
                  url = jellyfinUrl;
                  key = "{{HOMEPAGE_VAR_JELLYFIN_API_KEY}}";
                };
              };
            }
            {
              "Audiobookshelf" = {
                icon = "audiobookshelf.svg";
                href = audiobookshelfUrl;
                description = "Audiobooks";
                widget = {
                  type = "audiobookshelf";
                  url = audiobookshelfUrl;
                  key = "{{HOMEPAGE_VAR_AUDIOBOOKSHELF_API_KEY}}";
                };
              };
            }
            {
              "Navidrome" = {
                icon = "navidrome.svg";
                href = navidromeUrl;
                description = "Music";
                widget = {
                  type = "navidrome";
                  url = navidromeUrl;
                  user = "fkoehler";
                  token = "{{HOMEPAGE_VAR_NAVIDROME_API_KEY}}";
                  salt = "{{HOMEPAGE_VAR_NAVIDROME_SALT}}";
                };
              };
            }
            {
              "Invidious" = {
                icon = "invidious.svg";
                href = invidiousUrl;
                description = "Watch YouTube without distractions";
              };
            }
            {
              "tinyMediaManager" = {
                href = tinymediamanagerUrl;
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
                href = nextcloudUrl;
                description = "Personal cloud";
                widget = {
                  type = "nextcloud";
                  url = nextcloudUrl;
                  key = "{{HOMEPAGE_VAR_NEXTCLOUD_API_KEY}}";
                };
              };
            }
            {
              "Paperless" = {
                icon = "paperless-ngx.svg";
                href = paperlessUrl;
                description = "Documents";
                widget = {
                  type = "paperlessngx";
                  url = paperlessUrl;
                  key = "{{HOMEPAGE_VAR_PAPERLESS_API_KEY}}";
                };
              };
            }
            {
              "Forgejo" = {
                icon = "forgejo.svg";
                href = forgejoUrl;
                description = "Git";
                widget = {
                  type = "gitea";
                  url = forgejoUrl;
                  key = "{{HOMEPAGE_VAR_FORGEJO_API_KEY}}";
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
        "127.0.0.1:${toString port}" = { };
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
