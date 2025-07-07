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
  name = "audiobookshelf";
  ip = "172.22.1.102";
in
libContainer.mkContainer rec {
  inherit name ip;
  hostName = "audiobooks";
  inherit (config.services.audiobookshelf) port;
  bindMounts = {
    "/etc/resolv.conf" = {
      hostPath = "/etc/resolv.conf";
      isReadOnly = true;
    };
    "/var/lib/audiobookshelf" = {
      hostPath = "/containers/audiobookshelf/app";
      isReadOnly = false;
    };
    "/audiobooks" = {
      hostPath = "/media/tank1/media/audiobooks";
      isReadOnly = false;
    };
    "/audiobooks_perry_rhodan" = {
      hostPath = "/media/tank1/media/audiobooks_perry_rhodan";
      isReadOnly = false;
    };
    "/podcasts" = {
      hostPath = "/media/tank0/media/podcasts";
      isReadOnly = false;
    };
  };
  extraConfig = _: {
    services = {
      audiobookshelf = {
        enable = true;
        host = "0.0.0.0";
        inherit port;
      };
    };
  };
  sanoidDataset = "rpool/containers/${name}";
}
