{
  lib,
  pkgs,
  config,
  stateVersion,
  nodeConfig,
  ...
}:
let
  libContainer = import ./lib.nix {
    inherit
      lib
      pkgs
      config
      stateVersion
      nodeConfig
      ;
  };
  name = "homepage";
  ip = "172.22.1.120";
in
libContainer.mkContainer rec {
  inherit name ip;
  hostName = "homepage";
  port = config.services.homepage-dashboard.listenPort;
  bindMounts = {
    "${config.sops.templates."homepage-dashboard.env".path}".isReadOnly = true;
  };
  extraConfig = _: {
    services.homepage-dashboard = {
      enable = true;
      listenPort = port;
      environmentFile = "${config.sops.templates."homepage-dashboard.env".path}";
      allowedHosts = "127.0.0.1:${toString port},localhost:${toString port},${hostName}.${nodeConfig.domain}";
      services = [
        {
          "Media" = [
            {
              "Audiobookshelf" =
                let
                  url = "https://audiobooks.${nodeConfig.domain}";
                in
                {
                  icon = "audiobookshelf.svg";
                  href = url;
                  description = "Audiobooks and podcasts";
                  widget = {
                    type = "audiobookshelf";
                    inherit url;
                    key = "{{HOMEPAGE_VAR_AUDIOBOOKSHELF_KEY}}";
                  };
                };
            }
            {
              "Navidrome" =
                let
                  url = "https://music.${nodeConfig.domain}";
                in
                {
                  icon = "navidrome.svg";
                  href = url;
                  description = "Music";
                  widget = {
                    type = "navidrome";
                    inherit url;
                    user = "fkoehler";
                    token = "{{HOMEPAGE_VAR_NAVIDROME_KEY}}";
                    randomsalt = "{{HOMEPAGE_VAR_NAVIDROME_SALT}}";
                  };
                };
            }
            {
              "Immich" =
                let
                  url = "https://photos.${nodeConfig.domain}";
                in
                {
                  icon = "immich.svg";
                  href = url;
                  description = "Photos";
                  widget = {
                    type = "immich";
                    inherit url;
                    key = "{{HOMEPAGE_VAR_IMMICH_KEY}}";
                    version = 2;
                  };
                };
            }
          ];
        }
        {
          "Productivity" = [
            {
              "Paperless" =
                let
                  url = "https://docs.${nodeConfig.domain}";
                in
                {
                  icon = "paperless-ngx.svg";
                  href = url;
                  description = "Documents";
                  widget = {
                    type = "paperlessngx";
                    inherit url;
                    key = "{{HOMEPAGE_VAR_PAPERLESS_KEY}}";
                  };
                };
            }
            {
              "Karakeep" =
                let
                  url = "https://bookmarks.${nodeConfig.domain}";
                in
                {
                  icon = "karakeep.svg";
                  href = url;
                  description = "Bookmarks";
                };
            }
            {
              "Stirling PDF" =
                let
                  url = "https://pdfs.${nodeConfig.domain}";
                in
                {
                  icon = "stirling-pdf.svg";
                  href = url;
                  description = "PDF Editor";
                };
            }
            {
              "Vaultwarden" =
                let
                  url = "https://vault.${nodeConfig.domain}";
                in
                {
                  icon = "vaultwarden.svg";
                  href = url;
                  description = "Password vault";
                };
            }
          ];
        }
        {
          "Monitoring" = [
            {
              "Healthchecks" =
                let
                  url = "https://health.${nodeConfig.domain}";
                in
                {
                  icon = "healthchecks.svg";
                  href = url;
                  description = "Job monitoring";
                  widget = {
                    type = "healthchecks";
                    inherit url;
                    key = "{{HOMEPAGE_VAR_HEALTHCHECKS_KEY}}";
                  };
                };
            }
          ];
        }
      ];
    };
  };
}
// {
  sops = {
    secrets = {
      "services/homepage/services/audiobookshelf/key" = { };
      "services/homepage/services/immich/key" = { };
      "services/homepage/services/healthchecks/key" = { };
      "services/homepage/services/navidrome/key" = { };
      "services/homepage/services/navidrome/salt" = { };
      "services/homepage/services/paperless/key" = { };
    };
    templates."homepage-dashboard.env" = {
      content = ''
        HOMEPAGE_VAR_AUDIOBOOKSHELF_KEY=${
          config.sops.placeholder."services/homepage/services/audiobookshelf/key"
        }
        HOMEPAGE_VAR_HEALTHCHECKS_KEY=${
          config.sops.placeholder."services/homepage/services/healthchecks/key"
        }
        HOMEPAGE_VAR_IMMICH_KEY=${config.sops.placeholder."services/homepage/services/immich/key"}
        HOMEPAGE_VAR_NAVIDROME_KEY=${config.sops.placeholder."services/homepage/services/navidrome/key"}
        HOMEPAGE_VAR_NAVIDROME_SALT=${config.sops.placeholder."services/homepage/services/navidrome/salt"}
        HOMEPAGE_VAR_PAPERLESS_KEY=${config.sops.placeholder."services/homepage/services/paperless/key"}
      '';
    };
  };
}
