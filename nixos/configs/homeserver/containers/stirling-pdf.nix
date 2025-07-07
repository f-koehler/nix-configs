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
  name = "stirling-pdf";
  ip = "172.22.1.119";
in
libContainer.mkContainer rec {
  inherit name ip;
  hostName = "pdfs";
  port = 8080;
  extraConfig = _: {
    services.stirling-pdf = {
      enable = true;
      environment = {
        SERVER_PORT = port;
      };
    };
  };
}
