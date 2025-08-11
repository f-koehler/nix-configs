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
  name = "karakeep";
  ip = "172.22.1.124";
  port = 12345;
in
libContainer.mkContainer rec {
  inherit name ip;
  hostName = "bookmarks";
  inherit port;
  bindMounts = {
    "/var/lib/karakeep" = {
      hostPath = "/containers/karakeep/app";
      isReadOnly = false;
    };
  };
  extraConfig = _: {
    services.karakeep = {
      enable = true;
      browser.enable = true;
      extraEnvironment = {
        DISABLE_NEW_RELEASE_CHECK = "true";
        DB_WAL_MODE = "true";
        PORT = "${toString port}";
      };
    };
  };
  # sanoidDataset = "rpool/containers/${name}";
}
