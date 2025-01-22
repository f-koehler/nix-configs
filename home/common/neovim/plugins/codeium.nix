{
  lib,
  pkgs,
  nodeConfig,
  ...
}:
{
  programs.nixvim.plugins.codeium-nvim = {
    enable = nodeConfig.isWorkstation;
    settings = {
      tools = {
        curl = lib.getExe pkgs.curl;
        gzip = lib.getExe pkgs.gzip;
        uname = lib.getExe' pkgs.coreutils "uname";
        uuidgen = lib.getExe' pkgs.util-linux "uuidgen";
      };
    };
  };
}
