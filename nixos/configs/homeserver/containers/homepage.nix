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
  extraConfig = _: {
    services.homepage-dashboard = {
      enable = true;
      listenPort = port;
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
                  # widget = {
                  #   type = "audiobookshelf";
                  #   inherit url;
                  #   key = "{{HOMEPAGE_VAR_AUDIOBOOKSHELF_API_KEY}}";
                  # };
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
                  # widget = {
                  #   type = "navidrome";
                  #   inherit url;
                  # user = "";
                  #   token = "{{HOMEPAGE_VAR_AUDIOBOOKSHELF_API_KEY}}";
                  #   randomsalt = "";
                  # };
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
                  # widget = {
                  #   type = "immich";
                  #   inherit url;
                  #   key = "{{HOMEPAGE_VAR_AUDIOBOOKSHELF_API_KEY}}";
                  #   version = 2;
                  # };
                };
            }
          ];
        }
        # TODO(fk): add stirling PDF to productivity group
      ];
    };
  };
}
