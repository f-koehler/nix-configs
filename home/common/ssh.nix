{
  lib,
  nodeConfig,
  ...
}:
lib.mkIf nodeConfig.isWorkstation {
  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "mbp2021" = {
        hostname = "mbp2021.corgi-dojo.ts.net";
        port = 22;
        user = "fkoehler";
      };
      "homeserver" = {
        hostname = "homeserver.corgi-dojo.ts.net";
        user = "fkoehler";
      };
      "desktop" = {
        hostname = "desktop.corgi-dojo.ts.net";
        user = "fkoehler";
      };
      "desktop-ubuntu" = {
        hostname = "desktop-ubuntu.corgi-dojo.ts.net";
        user = "fkoehler";
      };
      vps = {
        hostname = "194.61.28.200";
      };
    };
  };
}
