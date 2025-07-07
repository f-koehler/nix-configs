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
  name = "navidrome";
  ip = "172.22.1.103";
in
libContainer.mkContainer rec {
  inherit name ip;
  hostName = "music";
  port = config.services.navidrome.settings.Port;
  bindMounts = {
    "/soundtracks" = {
      hostPath = "/media/tank1/media/soundtracks";
      isReadOnly = true;
    };
  };
  extraConfig = _: {
    services.navidrome = {
      enable = true;
      settings = {
        Port = port;
        Address = "0.0.0.0";
        MusicFolder = "/soundtracks";
        DataFolder = "/data";
        # TODO(fk): use domain here once defined
        BaseUrl = "https://${hostName}.corgi-dojo.ts.net";
      };
    };
  };
}
